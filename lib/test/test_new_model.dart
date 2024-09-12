import 'package:OACrugs/test/test_change_color_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

import '../const.dart';

class NewShapeColorScreen extends StatefulWidget {
  @override
  _ShapeColorScreenState createState() => _ShapeColorScreenState();
}

class _ShapeColorScreenState extends State<NewShapeColorScreen> {
  String? originalImageBase64; // To hold the original image in base64
  String? modifiedImageBase64; // To hold the modified image in base64

  @override
  void initState() {
    super.initState();
    _loadImageFromAssets();
  }

  // Load the image from assets and convert to base64
  Future<void> _loadImageFromAssets() async {
    final ByteData data = await rootBundle.load('assets/image/carpetlayout1.png');
    setState(() {
      originalImageBase64 = base64Encode(data.buffer.asUint8List());
    });
  }

  // Function to call the new API and replace the color
  Future<void> _replaceColor() async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.39:5000/replace-color'),
      );

      // Add the image as a file field named 'image'
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        base64Decode(originalImageBase64!),
        filename: 'carpetlayout1.png',
      ));

      // Add other required fields (shape_name, replacement_color)
      request.fields['shape_name'] = 'B';
      request.fields['replacement_color'] = '#ff4f33';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
    print(response.statusCode);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          modifiedImageBase64 = data['modified_image'];
        });
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
        title: Text('Color Replacement'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center( // Center the content horizontally
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute space evenly
          children: [
            // Original Image
            _buildImageContainer(originalImageBase64, 'Original Image'),

            // Replace Color Button
            ElevatedButton(
              onPressed: _replaceColor,
              child: Text('Replace Color'),
            ),

            // Modified Image (initially null)
            _buildImageContainer(modifiedImageBase64, 'Modified Image'),
          ],
        ),
      ),
    );
  }

  // Helper function to build image containers
  Widget _buildImageContainer(String? imageBase64, String title) {
    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: imageBase64 == null
              ? AssetImage('assets/image/carpetlayout1.png') as ImageProvider
              : MemoryImage(base64Decode(imageBase64)),
          fit: BoxFit.contain,
        ),
      ),
      child: Center( // Center the title within the container
        child: imageBase64 == null
            ? CircularProgressIndicator() // Show loading indicator if image is not yet loaded
            : Text(title, style: TextStyle(color: Colors.black)),
      ),
    );
  }
}