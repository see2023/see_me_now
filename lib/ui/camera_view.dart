import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:see_me_now/ml/me.dart';
import 'package:see_me_now/ui/blaze_pose_detector_view.dart';
import 'package:see_me_now/ui/face_detector_view.dart';
import 'package:see_me_now/ui/label_detector_view.dart';

class CameraView extends StatefulWidget {
  const CameraView(
      {super.key, this.initialDirection = CameraLensDirection.front});

  /// Callback to pass results after inference to [HomeView]
  // final Function(List<Recognition> recognitions) resultsCallback;
  // const CameraView(this.resultsCallback);

  final CameraLensDirection initialDirection;

  @override
  State<CameraView> createState() => CameraViewState();
  static late double ratio;
  static late Size inputImageSize;
  static const int detectInterval = 1000; // ms
}

class CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  late List<CameraDescription> _cameras;
  late int _cameraIndex = -1;
  CameraController? _cameraController;

  static const _blazeEnabled = false;
  static final _blazePoseDetectorViewState =
      GlobalKey<BlazePoseDetectorViewState>();
  final _blazePoseDetectorView = _blazeEnabled
      ? BlazePoseDetectorView(key: _blazePoseDetectorViewState)
      : null;

  static const _labelEnabled = true;
  static final _labelDetectorViewKey = GlobalKey<ImageLabelViewState>();
  final _labelDetectorView =
      _labelEnabled ? ImageLabelView(key: _labelDetectorViewKey) : null;

  static const _faceEnabled = true;
  static final _faceDetectorViewKey = GlobalKey<FaceDetectorViewState>();
  final _faceDetectorView =
      _faceEnabled ? FaceDetectorView(key: _faceDetectorViewKey) : null;

  static bool _predicting = false;
  static bool _cameraInited = false;
  static bool _cameraIniting = false;
  static InputImageRotation currentRotation = InputImageRotation.rotation0deg;
  bool _viewDisposed = false;
  int _processCount = 0;
  int _frameCount = 0;
  int _lastDetect = 0;
  AppLifecycleState _appState = AppLifecycleState.resumed;

  @override
  void initState() {
    Log.log.fine('CameraView initState');
    super.initState();
    initStateAsync();
  }

  void initStateAsync() async {
    WidgetsBinding.instance.addObserver(this);

    _cameras = await availableCameras();
    Log.log.info('Available cameras: $_cameras $this');
    // find default camera
    if (_cameras.isNotEmpty) {
      _cameraIndex = _cameras.indexWhere(
          (element) => element.lensDirection == widget.initialDirection);
      if (_cameraIndex == -1) {
        _cameraIndex = 0;
      }
    }
    startCameraAsync();
  }

  Future<void> startCameraAsync() async {
    if (_cameraIniting || _cameraInited || _cameraController != null) {
      Log.log.fine(
          'camera busing[$_cameraIniting, $_cameraInited], startCameraAsync return');
      return;
    }
    _cameraIniting = true;
    try {
      /// low: 352x288 on iOS, 240p (320x240) on Android and Web
      /// medium: 480p (640x480 on iOS, 720x480 on Android and Web)
      _cameraController = CameraController(
          _cameras[_cameraIndex], ResolutionPreset.low,
          enableAudio: false);
      Log.log.info('starting camera stream');
      await _cameraController?.initialize();
      await _cameraController?.startImageStream(onLatestImageAvailable);

      /// previewSize is size of each image frame captured by controller
      Size? previewSize = _cameraController?.value.previewSize;
      CameraView.inputImageSize = previewSize!;
      CameraView.ratio = previewSize.width / previewSize.height;
      Log.log.fine(
          "camera init, previewsSize: $previewSize, ratio: ${CameraView.ratio}");

      _lastDetect =
          DateTime.now().millisecondsSinceEpoch + CameraView.detectInterval;
      _predicting = false;
      _cameraInited = true;
      _cameraIniting = false;
    } catch (e) {
      Log.log.fine('startImageStream error, $e');
      _cameraIniting = false;
    }
  }

  Future<void> stopCamera() async {
    if (_cameraController != null) {
      await _cameraController?.stopImageStream();
      await _cameraController?.dispose();
      _cameraController = null;
    }
    _cameraInited = false;
  }

  @override
  Widget build(BuildContext context) {
    // Log.log.fine('CameraView build');
    // Return empty container while the camera is not initialized
    return Consumer<StatDataNotifier>(
      builder: (context, statDataNotify, child) {
        if (_viewDisposed ||
            DB.setting.enableCamera == false ||
            _cameraController == null ||
            !_cameraController!.value.isInitialized ||
            !_cameraInited) {
          return Container();
        }
        double boxHeight = 220;

        return SizedBox(
          height: boxHeight,
          width: boxHeight / CameraView.ratio,
          child: Transform.scale(
            scale: 1.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // camera
                Center(
                  child: CameraPreview(_cameraController!),
                ),
                // processors
                _blazeEnabled ? _blazePoseDetectorView! : Container(),
                _faceEnabled ? _faceDetectorView! : Container(),
                _labelEnabled ? _labelDetectorView! : Container(),
                // result string
                if (statDataNotify.currentStatus.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.1),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        statDataNotify.currentStatus,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<InputImage?> _formatCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = _cameras[_cameraIndex];
    InputImageRotation? imageRotation;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return null;

    Orientation currentOrientation = MediaQuery.of(context).orientation;
    if (currentOrientation == Orientation.landscape) {
      imageRotation =
          InputImageRotationValue.fromRawValue(camera.sensorOrientation - 270);
    } else {
      imageRotation =
          InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    }
    if (imageRotation == null) return null;
    currentRotation = imageRotation;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    return inputImage;
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  onLatestImageAvailable(CameraImage cameraImage) async {
    // If previous inference has not completed then return
    var uiThreadTimeStart = DateTime.now().millisecondsSinceEpoch;
    var uiThreadInferenceElapsedTime = 0;
    var frameCount = ++_frameCount;
    // Log.log.fine('onLatestImageAvailable got frame $_frameCount');
    if (_viewDisposed) {
      Log.log.fine('onLatestImageAvailable view disposed, return');
      return;
    }

    if (!_cameraInited ||
        !DB.setting.enableCamera ||
        _lastDetect + CameraView.detectInterval > uiThreadTimeStart) {
      // Log.log.fine(
      //     'Skipping frame: $_canProcess, $_lastDetect, $uiThreadTimeStart');
      setState(() {});
      return;
    }
    _lastDetect = uiThreadTimeStart;

    if (_predicting) {
      Log.log.finest('Busy!  Skipping frame $frameCount');
      setState(() {});
      return;
    }
    Log.log.finest('onLatestImageAvailable got frame $frameCount, check start');
    _lastDetect = uiThreadTimeStart;
    _predicting = true;
    // setState(() {});

    final InputImage? inputImage = await _formatCameraImage(cameraImage);
    if (inputImage == null ||
        (_blazeEnabled && _blazePoseDetectorViewState.currentState == null) ||
        (_labelEnabled && _labelDetectorViewKey.currentState == null) ||
        (_faceEnabled && _faceDetectorViewKey.currentState == null)) {
      setState(() {
        _predicting = false;
      });
      Log.log.fine(
          'Skipping frame $frameCount: inputImage is null or detector is null');
      return;
    }
    _processCount++;

    bool hasPerson = false;
    if (_labelEnabled) {
      uiThreadTimeStart = DateTime.now().millisecondsSinceEpoch;
      var labels =
          await _labelDetectorViewKey.currentState!.processImage(inputImage);
      uiThreadInferenceElapsedTime =
          DateTime.now().millisecondsSinceEpoch - uiThreadTimeStart;
      hasPerson = Me.checkHasPerson(labels);
      Log.log.fine(
          '$_processCount, label inference time: $uiThreadInferenceElapsedTime ms, hasPerson: $hasPerson');
      Me.cameraDataBus.broadcast(CameraData(
          type: CameraDataType.label,
          labels: labels,
          firstPhase: true,
          hasPerson: hasPerson,
          lastPhase: (!_blazeEnabled && !_faceEnabled) || !hasPerson));
    }

    if (_blazeEnabled && hasPerson) {
      uiThreadTimeStart = DateTime.now().millisecondsSinceEpoch;
      var poses = await _blazePoseDetectorViewState.currentState!
          .processImage(inputImage);
      uiThreadInferenceElapsedTime =
          DateTime.now().millisecondsSinceEpoch - uiThreadTimeStart;
      Log.log.fine(
          '$_processCount, blaze pose inference time: $uiThreadInferenceElapsedTime ms');
      Me.cameraDataBus.broadcast(CameraData(
          type: CameraDataType.pose,
          poses: poses,
          firstPhase: !_labelEnabled,
          lastPhase: !_faceEnabled));
    }

    if (_faceEnabled && hasPerson) {
      uiThreadTimeStart = DateTime.now().millisecondsSinceEpoch;
      var faces =
          await _faceDetectorViewKey.currentState!.processImage(inputImage);
      uiThreadInferenceElapsedTime =
          DateTime.now().millisecondsSinceEpoch - uiThreadTimeStart;
      Log.log.fine(
          '$_processCount, face inference time: $uiThreadInferenceElapsedTime ms');
      Me.cameraDataBus.broadcast(CameraData(
          type: CameraDataType.face,
          faces: faces,
          firstPhase: !_labelEnabled && !_blazeEnabled,
          lastPhase: true));
    }
    // set predicting to false to allow new frames
    _predicting = false;
    Log.log.finest('onLatestImageAvailable frame $frameCount check finished');
    if (_appState != AppLifecycleState.paused && !_viewDisposed) {
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        _appState = AppLifecycleState.paused;
        try {
          Log.log.warning('AppLifecycleState.paused, stopping camera stream');
          await stopCamera();
          setState(() {});
        } catch (e) {
          Log.log.warning('Error stopping camera stream: $e');
        }
        break;
      case AppLifecycleState.resumed:
        _appState = AppLifecycleState.resumed;
        try {
          Log.log.info('AppLifecycleState.resumed, resuming camera stream');
          await startCameraAsync();
        } catch (e) {
          Log.log.warning('Error starting camera stream: $e');
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    _viewDisposed = true;
    Log.log.info("camera view disposed");
    stopCamera();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
