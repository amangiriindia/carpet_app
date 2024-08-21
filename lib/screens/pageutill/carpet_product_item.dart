import 'package:flutter/material.dart';
import 'dart:typed_data';

class CarpetItemCard extends StatelessWidget {
  final Uint8List imageData;
  final String text;
  final String price;
  final VoidCallback onTap;

  CarpetItemCard({
    required this.imageData,
    required this.text,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(12.0),
        height: 280.0, // Fixed card height
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              child: Image.memory(
                imageData,
                fit: BoxFit.cover,
                height: 180.0, // Fixed image height
                width: double.infinity,
              ),
            ),
            // Name & Price Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '₹ $price',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
