import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AlchemyCanvas {
  late String id;
  late List<AlchemyLayer> layers;
  late List<AlchemyPen> pens;
  double scalingFactor = 1;

  AlchemyCanvas({this.id = ""}) {
    if (id.isEmpty) {
      id = const Uuid().v4();
    }

    layers = [];
    layers.addAll(AlchemyLayer.getDefaultLayers());

    pens = [];
    pens.addAll(AlchemyPen.getDefaultPenAndMarker(
      layers.last,
      layers.first,
    ));
  }
}

class AlchemyLayer {
  late String id;
  late int index;
  late String name;
  late List<AlchemyPath> paths;

  AlchemyLayer(
    this.index, {
    this.name = "Layer",
    this.id = "",
  }) {
    if (id.isEmpty) {
      id = const Uuid().v4();
    }

    paths = [];
  }

  static List<AlchemyLayer> getDefaultLayers() {
    return [
      AlchemyLayer(
        0,
        name: "Background",
      ),
      AlchemyLayer(
        1,
        name: "Foreground",
      ),
    ];
  }
}

class AlchemyPath {
  late String id;
  late int index;
  late Paint paint;
  late List<Offset> points;

  AlchemyPath(this.points, this.paint, {this.id = "", this.index = 0}) {
    if (id.isEmpty) {
      id = const Uuid().v4();
    }
  }
}

class AlchemyPen {
  late String id;
  Paint paint;
  AlchemyLayer assignedLayer;

  AlchemyPen(this.paint, this.assignedLayer, {this.id = ""}) {
    if (id.isEmpty) {
      id = const Uuid().v4();
    }
  }

  static List<AlchemyPen> getDefaultPenAndMarker(
    AlchemyLayer foregroundLayer,
    AlchemyLayer backgroundLayer,
  ) {
    return [
      AlchemyPen(
          Paint()
            ..color = Colors.black
            ..isAntiAlias = true
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.round,
          foregroundLayer),
      AlchemyPen(
          Paint()
            ..color = Colors.blue
            ..isAntiAlias = true
            ..strokeWidth = 5
            ..strokeCap = StrokeCap.round,
          backgroundLayer),
    ];
  }
}
