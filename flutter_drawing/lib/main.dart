// main.dart

import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing/canvasState.dart';
import 'package:flutter_drawing/drawingPainter.dart';
import 'package:flutter_drawing/model.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyPainter extends StatefulWidget {
  @override
  _MyPainterState createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter> {
  CanvasState stateObject = CanvasState();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('some Drawing exercise'),
        backgroundColor: Colors.deepPurple[600],
      ),
      body: ChangeNotifierProvider(
        create: (context) => stateObject,
        child: Consumer<CanvasState>(
          builder: (context, canvasState, child) => Listener(
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
      floatingActionButton: SpeedDial(
        child: Icon(Icons.android),
        backgroundColor: Colors.deepPurple[600],
        children: [
          SpeedDialChild(
            label: "Pens",
            child: SpeedDial(
              child: Icon(Icons.edit),
              children: [..._buildPenChose(stateObject)],
            ),
          ),
          SpeedDialChild(
            child: Icon(Icons.layers),
            label: "Layers",
            onTap: () {
              _scaffoldKey.currentState?.showBottomSheet((context) {
                return Container(
                  height: 100.0,
                  color: Colors.grey,
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: [
                            Tab(text: "Pens"),
                            Tab(text: "Layers"),
                            Tab(text: "Tools"),
                          ],
                        ),
                        /* Container(
                          child: TabBarView(
                            children: [
                              Container(
                                  height: 50,
                                  width: 100,
                                  child: Text("PENPENPEN")),
                              Container(
                                  height: 50,
                                  width: 100,
                                  child: Text("LAYERLAYER")),
                              Container(
                                  height: 50,
                                  width: 100,
                                  child: Text("TOOOOOL")),
                            ],
                          ),
                        ), */
                      ],
                    ),
                  ),
                );
              });
            },
            onLongPress: () {},
          ),
          SpeedDialChild(
            child: Icon(Icons.clear_all),
            label: "Clear layer / canvas",
            onTap: () {},
            onLongPress: () {},
          ),
        ],
      ),
    );
  }

  List<SpeedDialChild> _buildPenChose(CanvasState state) {
    var pens = state.canvas.pens;
    bool isSelected = false;
    List<SpeedDialChild> result = [];

    for (var pen in pens) {
      isSelected = state.currentDrawingPen == pen;
      result.add(SpeedDialChild(
        child: const Icon(Icons.edit),
        labelWidget: Container(
          height: 20,
          width: 40,
          child: Divider(
            color: pen.paint.color,
            thickness: pen.paint.strokeWidth,
          ),
        ),
        onTap: () => state.switchPen(pen),
        foregroundColor: pen.paint.color,
        backgroundColor: isSelected ? Colors.grey[200] : Colors.white,
      ));
    }
    return result;
  }
}
