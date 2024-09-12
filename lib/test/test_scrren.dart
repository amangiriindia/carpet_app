import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

import '../constant/const.dart';

class ColorScreen extends StatefulWidget {
  @override
  _ColorScreenState createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  List<String> uniqueColors = [];
  String targetColor = ''; // To store the target color on which user drops the color
  Uint8List? modifiedImage; // This will hold the modified image

  @override
  void initState() {
    super.initState();
    fetchColorsFromAPI();
  }

  Future<void> fetchColorsFromAPI() async {
    try {
      // Load the image from assets initially
      final ByteData data = await rootBundle.load('assets/image/test_img.png');
      final Uint8List imageBytes = data.buffer.asUint8List();

      // Create a multipart request to fetch unique colors
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${APIConstants.LOCALHOST}get-unique-colors'),
      );

      // Add the image as a file field named 'image'
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'test_img.png',
      ));

      // Send the request and capture the response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Check the status code and decode the body if successful
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          uniqueColors = List<String>.from(data['unique_colors']);
        });
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> replaceColorAPI(String targetColor, String replacementColor) async {
    try {
      Uint8List imageBytes;

      // Check if there's a modified image, if not, use the original from assets
      if (modifiedImage == null) {
        final ByteData data = await rootBundle.load('assets/image/test_img.png');
        imageBytes = data.buffer.asUint8List();
      } else {
        // Use the modified image for subsequent requests
        imageBytes = modifiedImage!;
      }

      // Create a multipart request for the replace-color API
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${APIConstants.LOCALHOST}replace-color'),
      );

      // Add the modified image and color details
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'modifiedImage.png', // Dynamically send modified image
      ));
      request.fields['target_color'] = targetColor;
      request.fields['replacement_color'] = replacementColor;

      // Send the request and capture the response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if 'modified_image' key exists and is not null
        if (data.containsKey('modified_image') && data['modified_image'] != null) {
          String base64Image = data['modified_image'];

          // Decode the base64 image and store it as the new modified image
          setState(() {
            modifiedImage = base64Decode(base64Image); // Store the updated image
            targetColor = replacementColor; // Update target color
          });
        } else {
          print('API Error: Missing or null "modified_image" key');
        }
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unique Colors from API'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Top image section
          // Top image section
          Container(
            width: double.infinity, // Ensure the container uses the full width
            height: 500, // Set a fixed height for the image container
            decoration: BoxDecoration(
              image: DecorationImage(
                image: modifiedImage == null
                    ? AssetImage('assets/image/test_img.png') as ImageProvider
                    : MemoryImage(modifiedImage!), // Dynamically display the modified image
                fit: BoxFit.contain, // Ensure the image fits within the container
              ),
            ),
          ),
          SizedBox(height: 20),

          // Colors grid section (droppable areas)
          Expanded(
            child: uniqueColors.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of boxes per row
                  childAspectRatio: 2, // Make the boxes rectangular
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: uniqueColors.length,

                itemBuilder: (context, index) {
                  return DragTarget<String>(
                    onAccept: (replacementColor) {
                      // Call the API to replace the color in the image
                      replaceColorAPI(uniqueColors[index], replacementColor);

                      // Update the color of the box locally
                      setState(() {
                        uniqueColors[index] = replacementColor; // Update the box color
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(_getColorFromHex(uniqueColors[index])),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            uniqueColors[index].toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }


            ),
          ),

          // Draggable color boxes at the bottom
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDraggableColorBox('Red', Colors.red, '#FF0000'),
                _buildDraggableColorBox('Green', Colors.green, '#00FF00'),
                _buildDraggableColorBox('Blue', Colors.blue, '#0000FF'),
                _buildDraggableColorBox('Yellow', Colors.yellow, '#FFFF00'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to convert hex string to Color object
  int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  // Helper to create draggable color boxes
  Widget _buildDraggableColorBox(String label, Color color, String hexCode) {
    return Draggable<String>(
      data: hexCode,
      feedback: Container(
        width: 50,
        height: 50,
        color: color,
      ),
      childWhenDragging: Container(
        width: 50,
        height: 50,
        color: color.withOpacity(0.5),
      ),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}