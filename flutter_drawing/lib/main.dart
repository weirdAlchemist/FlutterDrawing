// main.dart

import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing/canvasState.dart';
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
  Color selectedColor = Colors.red;
  bool selectedPenOrMarker = true;
  double strokeWidth = 5;

  double scalingFactor = 1;

  List<DrawingPoint> drawingPoints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('some Drawing exercise'),
        backgroundColor: Colors.deepPurple[600],
      ),
      body: ChangeNotifierProvider(
        create: (context) => CanvasState(),
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

                /* setState(() {
                  drawingPoints.add(
                    DrawingPoint(
                      details.localFocalPoint / scalingFactor,
                      Paint()
                        ..color = selectedColor
                        ..isAntiAlias = true
                        ..strokeWidth = strokeWidth
                        ..strokeCap = StrokeCap.round,
                      selectedPenOrMarker,
                      false,
                    ),
                  );
                }); */
              },
              onScaleUpdate: (details) {
                canvasState.addToPath(details.localFocalPoint);
                /* setState(() {
                  scalingFactor /= details.scale;
                  drawingPoints.add(
                    DrawingPoint(
                      details.localFocalPoint / scalingFactor,
                      Paint()
                        ..color = selectedColor
                        ..isAntiAlias = true
                        ..strokeWidth = strokeWidth
                        ..strokeCap = StrokeCap.round,
                      selectedPenOrMarker,
                      false,
                    ),
                  );
                }); */
              },
              onScaleEnd: (details) {
                /* setState(() {
                  drawingPoints.add(
                    DrawingPoint(
                      Offset(0, 0),
                      Paint(),
                      selectedPenOrMarker,
                      true,
                    ),
                  );
                }); */
              },
              child: CustomPaint(
                painter: _DrawingPainter(drawingPoints, scalingFactor),
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
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.grey[200],
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPenChose(Colors.red),
              _buildPenChose(Colors.blue),
              _buildPenChose(Colors.green),
              const Text("<~ Pens"),
              const Spacer(),
              IconButton(
                  onPressed: () => setState(() {
                        drawingPoints = [];
                      }),
                  icon: const Icon(Icons.clear)),
              const Spacer(),
              const Text("Marker ~>"),
              _buildMarkerChose(Colors.red),
              _buildMarkerChose(Colors.blue),
              _buildMarkerChose(Colors.green),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPenChose(Color color) {
    bool isSelected = selectedPenOrMarker && selectedColor == color;

    return GestureDetector(
      onTap: () => setState(() {
        selectedColor = color;
        strokeWidth = 5;

        selectedPenOrMarker = true;
      }),
      child: Container(
        height: 40,
        width: 40,
        child: Icon(
          Icons.balcony_rounded,
          color: color,
          size: (isSelected) ? 40 : 20,
        ),
      ),
    );
  }

  Widget _buildMarkerChose(Color color) {
    bool isSelected = !selectedPenOrMarker && selectedColor == color;

    return GestureDetector(
      onTap: () => setState(() {
        selectedColor = color;
        strokeWidth = 20;

        selectedPenOrMarker = false;
      }),
      child: Container(
        height: 40,
        width: 40,
        child: Icon(
          Icons.adb_rounded,
          color: color,
          size: (isSelected) ? 40 : 20,
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  late final List<DrawingPoint> drawingPoints;
  late final double scalingFactor;

  _DrawingPainter(this.drawingPoints, this.scalingFactor);

  @override
  void paint(Canvas canvas, Size size) {
    drawSomething(
      drawingPoints.where((element) => !element.penOrMarker).toList(),
      canvas,
    );

    drawSomething(
      drawingPoints.where((element) => element.penOrMarker).toList(),
      canvas,
    );
  }

  void drawSomething(List<DrawingPoint> drawingPoints, Canvas canvas) {
    for (var i = 0; i < drawingPoints.length - 1; i++) {
      if (!drawingPoints[i].endMarker && !drawingPoints[i + 1].endMarker) {
        Paint p = Paint()
          ..color = drawingPoints[i].paint.color
          ..isAntiAlias = true
          ..strokeWidth = drawingPoints[i].paint.strokeWidth
          ..strokeCap = StrokeCap.round;

        p.strokeWidth *= scalingFactor;

        canvas.drawLine(drawingPoints[i].offset * scalingFactor,
            drawingPoints[i + 1].offset * scalingFactor, p);
      } else if (!drawingPoints[i].endMarker &&
          drawingPoints[i + 1].endMarker) {
        Paint p = Paint()
          ..color = drawingPoints[i].paint.color
          ..isAntiAlias = true
          ..strokeWidth = drawingPoints[i].paint.strokeWidth
          ..strokeCap = StrokeCap.round;

        p.strokeWidth *= scalingFactor;

        canvas.drawPoints(
            PointMode.points, [drawingPoints[i].offset * scalingFactor], p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DrawingPoint {
  Offset offset;
  Paint paint;
  bool penOrMarker;
  bool endMarker;
  DrawingPoint(this.offset, this.paint, this.penOrMarker, this.endMarker);
}
