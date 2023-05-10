import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:see_me_now/ml/face_detector_painter.dart';
import 'package:see_me_now/data/log.dart';

class FaceDetectorView extends StatefulWidget {
  const FaceDetectorView({super.key});

  @override
  State<FaceDetectorView> createState() => FaceDetectorViewState();
}

class FaceDetectorViewState extends State<FaceDetectorView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      enableLandmarks: false,
      enableTracking: false,
      minFaceSize: 0.1,
      performanceMode: FaceDetectorMode.fast,
    ),
  );
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  @override
  void initState() {
    super.initState();
    Log.log.fine('FaceDetectorViewState.initState()');
    _canProcess = true;
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
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
              color: Colors.black.withOpacity(0.1),
              padding: const EdgeInsets.all(8),
              child: Text(
                _text!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
    // return Container(child: _customPaint);
  }

  Future<List<Face>> processImage(InputImage inputImage) async {
    if (!_canProcess) return [];
    if (_isBusy) return [];
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
      if (faces.isNotEmpty && faces[0].smilingProbability != null) {
        // _text = 'Smile: ${faces[0].smilingProbability!.toStringAsFixed(3)}';
      }
      Log.log.finest(_text);
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      Log.log.finest(text);
      _text = text;
      _customPaint = null;
    }
    _isBusy = false;

    if (mounted) {
      setState(() {});
    }
    return faces;
  }
}
