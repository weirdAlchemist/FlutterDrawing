import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_drawing/model.dart';

class CanvasState extends ChangeNotifier {
  final Paint currentDrawingPen = Paint();

  final AlchemyCanvas canvas = AlchemyCanvas();

  double scalingfactor = 1;

  late AlchemyPath currentDrawingPath;
  late AlchemyLayer currentDrawingLayer;

  CanvasState() {
    switchLayerByIndex(1);
    updatePen(Paint()
      ..color = Colors.black
      ..isAntiAlias = true
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round);
  }

  void updatePen(Paint newPen) {
    currentDrawingPen.color = newPen.color;
    currentDrawingPen.strokeCap = newPen.strokeCap;
    currentDrawingPen.strokeWidth = newPen.strokeWidth;

    notifyListeners();
  }

  void updateScalingFactor(double delta) {
    scalingfactor *= delta;
    notifyListeners();
  }

  void startNewPath(Offset point) {
    currentDrawingPath =
        AlchemyPath([point / scalingfactor], currentDrawingPen);
    currentDrawingLayer.paths.add(currentDrawingPath);
    notifyListeners();
  }

  void addToPath(Offset point) {
    currentDrawingPath.points.add(point / scalingfactor);
    notifyListeners();
  }

  void switchLayerByID(String id) {
    currentDrawingLayer =
        canvas.layers.firstWhere((element) => element.id == id);

    notifyListeners();
  }

  void switchLayerByIndex(int index) {
    currentDrawingLayer =
        canvas.layers.firstWhere((element) => element.index == index);

    notifyListeners();
  }
}
