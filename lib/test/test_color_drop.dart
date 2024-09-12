import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share/share.dart';

class CarpetDesign extends StatefulWidget {
  @override
  _CarpetDesignPageState createState() => _CarpetDesignPageState();
}

class _CarpetDesignPageState extends State<CarpetDesign> {
  Color colorA = Colors.grey;
  Color colorB = Colors.grey;
  GlobalKey _globalKey = GlobalKey(); // Key for RepaintBoundary

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carpet Design'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveAsImage, // Save as Image
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: RepaintBoundary(
                key: _globalKey,
                child: CustomPaint(
                  painter: CarpetPainter(colorA: colorA, colorB: colorB),
                  child: Center(
                    child: Stack(
                      children: [
                        _buildDragTarget(
                          label: "A",
                          initialColor: colorA,
                          onColorDropped: (color) {
                            setState(() {
                              colorA = color;
                            });
                          },
                        ),
                        _buildDragTarget(
                          label: "B",
                          initialColor: colorB,
                          onColorDropped: (color) {
                            setState(() {
                              colorB = color;
                            });
                          },
                          offsetX: 0.5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildColorBox(Colors.red),
              _buildColorBox(Colors.blue),
              _buildColorBox(Colors.green),
              _buildColorBox(Colors.yellow),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorBox(Color color) {
    return Draggable<Color>(
      data: color,
      feedback: Container(
        width: 50,
        height: 50,
        color: color,
      ),
      child: Container(
        width: 50,
        height: 50,
        color: color,
      ),
    );
  }

  Widget _buildDragTarget({
    required String label,
    required Color initialColor,
    required Function(Color) onColorDropped,
    double offsetX = 0.0,
  }) {
    return Positioned(
      left: MediaQuery.of(context).size.width * offsetX,
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
      child: DragTarget<Color>(
        onAccept: (color) {
          onColorDropped(color);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            decoration: BoxDecoration(
              color: initialColor,
              border: Border.all(color: Colors.black, width: 2.0),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveAsImage() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = (await getApplicationDocumentsDirectory()).path;
      final imgFile = File('$directory/carpet_design.png');
      imgFile.writeAsBytes(pngBytes);

      // Share the image
      Share.shareFiles([imgFile.path], text: 'Check out my carpet design!');
    } catch (e) {
      print(e.toString());
    }
  }
}

class CarpetPainter extends CustomPainter {
  final Color colorA;
  final Color colorB;

  CarpetPainter({required this.colorA, required this.colorB});

  @override
  void paint(Canvas canvas, Size size) {
    // No need to paint here as we are handling it in DragTarget
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
