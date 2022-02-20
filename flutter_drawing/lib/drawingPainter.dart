import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_drawing/model.dart';

class DrawingPainter extends CustomPainter {
  late final AlchemyCanvas alchemyCanvas;
  late final double scalingFactor;

  DrawingPainter(this.alchemyCanvas);

  @override
  void paint(Canvas canvas, Size size) {
    for (var layer in alchemyCanvas.layers) {
      for (var path in layer.paths) {
        drawPath(path, canvas);
      }
    }
  }

  void drawPath(AlchemyPath path, Canvas canvas) {
    for (var i = 0; i < path.points.length - 1; i++) {
      var curPoint = path.points[i];
      var nextPoint = path.points[i + 1];

      canvas.drawLine(curPoint, nextPoint, path.paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
