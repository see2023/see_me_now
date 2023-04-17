import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:see_me_now/ml/blaze_pose_painter.dart';
import 'package:see_me_now/data/log.dart';

class BlazePoseDetectorView extends StatefulWidget {
  const BlazePoseDetectorView({super.key});

  @override
  State<StatefulWidget> createState() {
    return BlazePoseDetectorViewState();
  }
}

class BlazePoseDetectorViewState extends State<BlazePoseDetectorView> {
  final PoseDetector _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
          mode: PoseDetectionMode.stream, model: PoseDetectionModel.accurate));
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  @override
  void initState() {
    super.initState();
    Log.log.fine('BlazePoseDetectorViewState.initState()');
    _canProcess = true;
  }

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(child: _customPaint),
        if (_text != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(8),
              child: Text(
                _text!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Future<List<Pose>> processImage(InputImage inputImage) async {
    if (!_canProcess) return [];
    if (_isBusy) return [];
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final poses = await _poseDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = PosePainter(poses, inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
      Log.log.fine('Poses found and painting: ${poses.length}');
    } else {
      Log.log.fine('Poses found: ${poses.length}');
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
    return poses;
  }
}
