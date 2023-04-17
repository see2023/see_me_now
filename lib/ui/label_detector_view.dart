import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:see_me_now/data/log.dart';
// import 'package:see_me_now/ml/label_detector_painter.dart';

class ImageLabelView extends StatefulWidget {
  const ImageLabelView({super.key});

  @override
  State<ImageLabelView> createState() => ImageLabelViewState();
}

class ImageLabelViewState extends State<ImageLabelView> {
  late ImageLabeler _imageLabeler;
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  @override
  void initState() {
    super.initState();

    _initializeLabeler();
  }

  @override
  void dispose() {
    _canProcess = false;
    _imageLabeler.close();
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

  void _initializeLabeler() async {
    // uncomment next line if you want to use the default model
    _imageLabeler =
        ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.5));

    // uncomment next lines if you want to use a local model
    // make sure to add tflite model to assets/ml
    // final path = 'assets/ml/lite-model_aiy_vision_classifier_birds_V1_3.tflite';
    // final path = 'assets/ml/object_labeler.tflite';
    // final modelPath = await _getModel(path);
    // final options = LocalLabelerOptions(modelPath: modelPath);
    // _imageLabeler = ImageLabeler(options: options);

    // uncomment next lines if you want to use a remote model
    // make sure to add model to firebase
    // final modelName = 'bird-classifier';
    // final response =
    //     await FirebaseImageLabelerModelManager().downloadModel(modelName);
    // print('Downloaded: $response');
    // final options =
    //     FirebaseLabelerOption(confidenceThreshold: 0.5, modelName: modelName);
    // _imageLabeler = ImageLabeler(options: options);

    _canProcess = true;
  }

  Future<List<ImageLabel>> processImage(InputImage inputImage) async {
    if (!_canProcess) return [];
    if (_isBusy) return [];
    _isBusy = true;
    setState(() {
      _text = '';
    });
    _customPaint = null;
    final labels = await _imageLabeler.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      // final painter = LabelDetectorPainter(labels);
      // _customPaint = CustomPaint(painter: painter);
      String text = 'Labels found: ${labels.length}\n\n';
      for (final label in labels) {
        text += 'Label: ${label.index} ${label.label}, '
            'Confidence: ${label.confidence.toStringAsFixed(2)}\n\n';
      }
      // _text = text;
      Log.log.fine(text);
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
    return labels;
  }

  // ignore: unused_element
  Future<String> _getModel(String assetPath) async {
    if (io.Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await io.Directory(dirname(path)).create(recursive: true);
    final file = io.File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
}
