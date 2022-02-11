// main.dart

import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing/canvasState.dart';
import 'package:flutter_drawing/drawingPainter.dart';
import 'package:flutter_drawing/model.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Custom Painter',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyPainter(),
    );
  }
}

class MyPainter extends StatefulWidget {
  @override
  _MyPainterState createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter> {
  CanvasState stateObject = CanvasState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('some Drawing exercise'),
        backgroundColor: Colors.deepPurple[600],
      ),
      body: ChangeNotifierProvider(
        create: (context) => stateObject,
        child: Consumer<CanvasState>(
          builder: (context, canvasState, chid) => Listener(
            onPointerSignal: (details) {
              if (details is PointerScrollEvent) {
                if (details.scrollDelta.dy > 0) {
                  canvasState.updateScalingFactor(0.95);
                } else if (details.scrollDelta.dy < 0) {
                  canvasState.updateScalingFactor(1.05);
                }
              }
            },
            child: GestureDetector(
              onScaleStart: (details) {
                canvasState.startNewPath(details.localFocalPoint);
              },
              onScaleUpdate: (details) {
                canvasState.addToPath(details.localFocalPoint);
              },
              onScaleEnd: (details) {},
              child: CustomPaint(
                painter: DrawingPainter(canvasState.canvas),
                child: Container(
                  height: MediaQuery.of(context).size.shortestSide,
                  width: MediaQuery.of(context).size.shortestSide,
                  decoration: BoxDecoration(border: Border.all()),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: ChangeNotifierProvider(
        create: (context) => stateObject,
        child: Consumer<CanvasState>(
          builder: (context, canvasState, chid) => BottomAppBar(
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ..._buildPenChose(canvasState),
                  const Text("<~ Pens"),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        canvasState.clearCanvas();
                      },
                      icon: const Icon(Icons.clear)),
                  const Spacer(),
                  const Text("Marker ~>"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPenChose(CanvasState state) {
    var pens = state.canvas.pens;

    List<Widget> result = [];

    for (var pen in pens) {
      result.add(
        GestureDetector(
          onTap: () => state.switchPen(pen),
          child: Container(
            height: 40,
            width: 40,
            child: Icon(
              Icons.balcony_rounded,
              color: pen.paint.color,
              size: state.currentDrawingPen == pen ? 40 : 20,
            ),
          ),
        ),
      );
    }
    return result;
  }
}
