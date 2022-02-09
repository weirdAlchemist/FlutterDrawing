import 'dart:ui';
import 'package:uuid/uuid.dart';

class AlchemyCanvas {
  late final String id;
  List<AlchemyLayer> layers = [];

  double scalingFactor = 1;

  AlchemyCanvas({
    this.id = "",
    this.layers = const [],
  }) {
    if (id.isEmpty) {
      id = const Uuid().v4();
    }

    layers.addAll(
      [
        AlchemyLayer(0),
        AlchemyLayer(1),
      ],
    );
  }
}

class AlchemyLayer {
  late final String id;
  int index = 0;
  String name = "Layer";
  List<AlchemyPath> paths = [];

  AlchemyLayer(
    this.index, {
    this.name = "Layer",
    this.id = "",
    this.paths = const [],
  }) {
    if (id.isEmpty) {
      id = const Uuid().v4();
    }
  }
}

class AlchemyPath {
  late final String id;
  int index = 0;
  late Paint paint;
  List<Offset> points = [];

  AlchemyPath(this.points, this.paint, {this.id = "", this.index = 0}) {
    if (id.isEmpty) {
      id = const Uuid().v4();
    }
  }
}
