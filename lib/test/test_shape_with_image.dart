import 'package:OACrugs/test/test_change_color_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

import '../constant/const.dart';

class ShapeColorScreen extends StatefulWidget {
  @override
  _ShapeColorScreenState createState() => _ShapeColorScreenState();
}

class _ShapeColorScreenState extends State<ShapeColorScreen> {
  String? labeledImageBase64; // To hold the base64 of the labeled image
  List<Map<String, dynamic>> shapesInfo = []; // To hold shape details

  @override
  void initState() {
    super.initState();
    fetchShapesAndColorsFromAPI();
  }

  Future<void> fetchShapesAndColorsFromAPI() async {
    try {
      // Load the image from assets initially
      final ByteData data = await rootBundle.load('assets/image/carpet_design1.png');
      final Uint8List imageBytes = data.buffer.asUint8List();

      // Create a multipart request to fetch shapes and colors
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${APIConstants.LOCALHOST}/get-shapes-and-colors'),
      );

      // Add the image as a file field named 'image'
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'testImage.png',
      ));

      // Send the request and capture the response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Check the status code and decode the body if successful
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          labeledImageBase64 = data['labeled_image'];
          shapesInfo = List<Map<String, dynamic>>.from(data['shapes_info']);
        });
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _navigateToChangeColorScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeColorScreen(
          imageBase64: labeledImageBase64!,
          shapesInfo: shapesInfo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shapes and Colors from API'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Display the labeled image
          Container(
            width: 300,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white, // Ensure a white background is set
              image: DecorationImage(
                image: labeledImageBase64 == null
                    ? AssetImage('assets/image/carpet_design1.png') as ImageProvider
                    : MemoryImage(base64Decode(labeledImageBase64!)), // Dynamically display the labeled image
                fit: BoxFit.contain, // Adjust the fit as needed
              ),
            ),
          ),
          SizedBox(height: 20),

          // Shapes and colors section
          Expanded(
            child: shapesInfo.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: shapesInfo.length,
              itemBuilder: (context, index) {
                final shape = shapesInfo[index];
                final color = Color(_getColorFromHex(shape['color']));
                final shapeName = shape['name'];
                final boundingBox = shape['bounding_box'];

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shape: $shapeName',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Color: ${shape['color']}',
                        style: TextStyle(
                          color: color,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        color: color,
                        width: boundingBox[2].toDouble(),
                        height: boundingBox[3].toDouble(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),

          // Change color button
          ElevatedButton(
            onPressed: _navigateToChangeColorScreen,
            child: Text('Change Color'),
          ),
        ],
      ),
    );
  }

  // Helper function to convert hex string to Color object
  int _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
