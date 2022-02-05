import 'dart:ui';
import 'package:uuid/uuid.dart';

class Canvas {
  late final String id;
  List<Layer> layers = [];

  double scalingFactor = 1;

  Canvas({
    this.id = "",
    this.layers = const [],
  }) {
    if (id.isEmpty) {
      id = const Uuid().v4();
    }
  }
}

class Layer {
  late final String id;
  int index = 0;
  String name = "Layer";
  List<Path> paths = [];

  Layer(
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

class Path {
  late final String id;
  int index = 0;
  late Paint paint;
  List<Offset> points = [];
}
