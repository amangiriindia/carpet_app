import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ConfirmOrderPage extends StatelessWidget {
  final String enquiryId;
  final String imagePath;
  final String carpetName;
  final String patternName;
  final String size;
  final double price;
  final String shape;
  final String description;

  const ConfirmOrderPage({
    super.key,
    required this.enquiryId,
    required this.imagePath,
    required this.carpetName,
    required this.patternName,
    required this.size,
    required this.price,
    required this.shape,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // Decode base64 string
    Uint8List? decodedImage;
    try {
      // Ensure the base64 string is correctly formatted
      if (imagePath.startsWith('data:image/') && imagePath.contains(';base64,')) {
        decodedImage = base64Decode(imagePath.split(',')[1]);
      } else {
        throw FormatException('Invalid image format');
      }
    } catch (e) {
      print('Error decoding image: $e');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Order'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Display
            if (decodedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  decodedImage,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            else
              const Center(
                child: Text('Error loading image'),
              ),
            const SizedBox(height: 20),

            // Carpet Name
            Text(
              carpetName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),

            // Price
            Text(
              'Price: ₹${price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),

            // Pattern Name
            Text(
              'Pattern: $patternName',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            // Size
            Text(
              'Size: $size',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            // Shape
            Text(
              'Shape: $shape',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              'Description:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Pay Now Button
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Add your payment logic here
                },
                child: const Text(
                  'Pay Now',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
