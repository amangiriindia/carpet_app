import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../const.dart';

class ChangeColorScreen extends StatefulWidget {
  final String imageBase64; // The labeled image in base64 format
  final List<Map<String, dynamic>> shapesInfo; // Shape information

  ChangeColorScreen({
    required this.imageBase64,
    required this.shapesInfo,
  });

  @override
  _ChangeColorScreenState createState() => _ChangeColorScreenState();
}

class _ChangeColorScreenState extends State<ChangeColorScreen> {
  late String modifiedImageBase64;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    modifiedImageBase64 = widget.imageBase64;
  }

  // Method to send the API request and update the image on the screen
  Future<void> replaceColor(String shapeName, String targetColor, String replacementColor) async {
    setState(() {
      isLoading = true; // Show loading indicator while making the API call
    });

    try {
      // API endpoint
      final url = Uri.parse('${APIConstants.LOCALHOST}/replace-color');

      // Convert the base64 image back to bytes
      Uint8List imageBytes = base64Decode(widget.imageBase64);
      final imageFile = MultipartFile.fromBytes('image', imageBytes, filename: 'image.png');

      // Create a request
      final request = http.MultipartRequest('POST', url);
      request.files.add(imageFile);
      request.fields['shape_name'] = shapeName;
      request.fields['target_color'] = targetColor;
      request.fields['replacement_color'] = replacementColor;

      // Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // If successful, update the image with the modified version
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody);
        setState(() {
          modifiedImageBase64 = jsonResponse['modified_image']; // Update the image on the screen
          isLoading = false; // Remove loading indicator
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Colors of Shapes'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader while API request is being processed
          : Column(
        children: [
          // Display the modified image
          Container(
            width: 300,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: MemoryImage(base64Decode(modifiedImageBase64)), // Display modified image
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Available colors to drag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildColorOptions(), // Create draggable color options
          ),
          SizedBox(height: 20),
          // Display list of shapes and their colors
          Expanded(
            child: ListView.builder(
              itemCount: widget.shapesInfo.length,
              itemBuilder: (context, index) {
                final shape = widget.shapesInfo[index];
                final shapeColor = Color(_getColorFromHex(shape['color']));
                final shapeName = shape['name'];

                return DragTarget<String>(
                  onWillAccept: (droppedColor) {
                    setState(() {}); // Rebuild to show hover effect
                    return true;
                  },
                  onAccept: (droppedColor) async {
                    await replaceColor(shapeName, shape['color'], droppedColor); // Trigger the API call
                  },
                  builder: (context, candidateData, rejectedData) {
                    final isHovered = candidateData.isNotEmpty; // Check if the shape is hovered

                    return ListTile(
                      title: Text(shapeName),
                      subtitle: Text('Color: ${shape['color']}'),
                      trailing: Container(
                        width: 30,
                        height: 30,
                        // Show the current shape color or the hovered color
                        color: isHovered
                            ? Color(_getColorFromHex(candidateData.first!))
                            : shapeColor,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method to build draggable color options
  List<Widget> _buildColorOptions() {
    final colors = ['#FF5733', '#33FF57', '#3357FF', '#FFFF33']; // Example color options
    return colors.map((colorHex) {
      return Draggable<String>(
        data: colorHex, // Pass the color hex as the draggable data
        feedback: Container(
          width: 50,
          height: 50,
          color: Color(_getColorFromHex(colorHex)),
        ),
        childWhenDragging: Container(
          width: 50,
          height: 50,
          color: Colors.grey, // Show grey box when dragged
        ),
        child: Container(
          width: 50,
          height: 50,
          color: Color(_getColorFromHex(colorHex)),
        ),
      );
    }).toList();
  }

  // Helper method to convert hex color to int
  int _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
