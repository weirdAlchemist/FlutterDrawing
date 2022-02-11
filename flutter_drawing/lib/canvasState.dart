import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_drawing/model.dart';

class CanvasState extends ChangeNotifier {
  final AlchemyCanvas canvas = AlchemyCanvas();

  double scalingfactor = 1;

  late AlchemyPen currentDrawingPen;
  late AlchemyLayer currentDrawingLayer;
  late AlchemyPath? currentDrawingPath;

  CanvasState() {
    switchLayerByIndex(1);
    switchPen(canvas.pens.first);
  }

  void addNewLayer() {
    int highestIndex = canvas.layers.last.index;
    AlchemyLayer newLayer = AlchemyLayer(++highestIndex);

    addLayer(newLayer);
  }

  //Layers
  void addLayer(AlchemyLayer newLayer) {
    canvas.layers.add(newLayer);
    canvas.layers.sort((a, b) => a.index.compareTo(b.index));
    notifyListeners();
  }

  void removeLayer(AlchemyLayer oldLayer) {
    canvas.layers.remove(oldLayer);
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

  void switchPen(AlchemyPen newPen) {
    currentDrawingPen = newPen;
    notifyListeners();
  }

  void updateScalingFactor(double delta) {
    scalingfactor *= delta;
    notifyListeners();
  }

  void startNewPath(Offset point) {
    currentDrawingPath =
        AlchemyPath([point / scalingfactor], currentDrawingPen.paint);
    currentDrawingLayer.paths.add(currentDrawingPath!);
    notifyListeners();
  }

  void addToPath(Offset point) {
    currentDrawingPath?.points.add(point / scalingfactor);
    notifyListeners();
  }

  void deletePath(AlchemyPath oldPath) {
    for (var l in canvas.layers) {
      l.paths.remove(oldPath);
    }
    notifyListeners();
  }

  void clearCanvas() {
    for (var l in canvas.layers) {
      clearLayer(l);
    }
    notifyListeners();
  }

  void clearLayer(AlchemyLayer layer) {
    for (var p in layer.paths) {
      deletePath(p);
    }
    notifyListeners();
  }
}
