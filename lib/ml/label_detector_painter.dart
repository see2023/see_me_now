import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:see_me_now/data/log.dart';

class LabelDetectorPainter extends CustomPainter {
  LabelDetectorPainter(this.labels);

  final List<ImageLabel> labels;

  @override
  void paint(Canvas canvas, Size size) {
    final ui.ParagraphBuilder builder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
          textAlign: TextAlign.left,
          fontSize: 23,
          textDirection: TextDirection.ltr),
    );

    builder.pushStyle(ui.TextStyle(color: Colors.lightBlue[900]));
    String totalLabels = '\n';
    for (final ImageLabel label in labels) {
      String text = 'Label: ${label.label}, ${label.index}, '
          'Confidence: ${label.confidence.toStringAsFixed(2)}\n';
      builder.addText(text);
      totalLabels += text;
    }
    Log.log.fine(totalLabels);
    builder.pop();

    canvas.drawParagraph(
      builder.build()
        ..layout(ui.ParagraphConstraints(
          width: size.width,
        )),
      const Offset(0, 0),
    );
  }

  @override
  bool shouldRepaint(LabelDetectorPainter oldDelegate) {
    return oldDelegate.labels != labels;
  }
}
