import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/profile_drawer.dart';
import '../notification_screen.dart';

class ConfirmOrderPage extends StatelessWidget {
  final String enquiryId;
  final String imagePath;
  final String carpetName;
  final String patternName;
  final String size;
  final double price;
  final String shape;
  final String description;
  final double patternPrice;
  final double sizePrice;
  final double gstPercent;
  final double shapePrice;
  final double colorPrice;

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
    required this.patternPrice,
    required this.sizePrice,
    required this.gstPercent,
    required this.shapePrice,
    required this.colorPrice,
  });

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Decode base64 string
    Uint8List? decodedImage;
    try {
      // Ensure the base64 string is correctly formatted
      if (imagePath.startsWith('data:image/') &&
          imagePath.contains(';base64,')) {
        decodedImage = base64Decode(imagePath.split(',')[1]);
      } else {
        throw FormatException('Invalid image format');
      }
    } catch (e) {
      print('Error decoding image: $e');
    }

    // Calculate individual prices and totals
    double subtotal =
        price + patternPrice + sizePrice + shapePrice + colorPrice;
    double gstAmount = subtotal * (gstPercent / 100);
    double totalPrice = subtotal + gstAmount;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      drawer: const NotificationScreen(),
      endDrawer: const ProfileDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed "Order Summary" Section
          Container(

            color: Colors.white,
            child: Row(
              children: [
                const SizedBox(width: 12),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(3.14),
                  child: IconButton(
                    icon:
                        const Icon(Icons.login_outlined, color: Colors.black54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 80),
                const Icon(Icons.list_alt_outlined, color: Colors.black54),
                const SizedBox(width: 4),
                const Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Display
                  if (decodedImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        decodedImage,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    )
                  else
                    const Center(
                      child: Text('Error loading image'),
                    ),
                  const SizedBox(height: 24),

                  // Carpet Name
                  Text(

                    carpetName,
                    style: const TextStyle(
                        fontSize: 18, ),
                  ),


                  // Details (Pattern, Size, Shape, Description) in a Dropdown
                  ExpansionTile(
                    title: const Text('Carpet Details',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Pattern:', patternName),
                              const SizedBox(height: 8),
                              _buildDetailRow('Size:', size),
                              const SizedBox(height: 8),
                              _buildDetailRow('Shape:', shape),
                              const SizedBox(height: 16),
                              const Text(
                                'Description:',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                description,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 0.0), // No margin needed for full width
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Price Breakdown Table
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(1),
                            },
                            children: [
                              _buildTableRow('Carpet Price:',
                                  '₹${price.toStringAsFixed(2)}'),
                              _buildTableRow('Pattern Price:',
                                  '₹${patternPrice.toStringAsFixed(2)}'),
                              _buildTableRow('Size Price:',
                                  '₹${sizePrice.toStringAsFixed(2)}'),
                              _buildTableRow('Shape Price:',
                                  '₹${shapePrice.toStringAsFixed(2)}'),
                              _buildTableRow('Color Price:',
                                  '₹${colorPrice.toStringAsFixed(2)}'),
                              TableRow(
                                children: [
                                  const SizedBox(height: 10),
                                  Container(),
                                ],
                              ),
                              _buildTableRow('Subtotal:',
                                  '₹${subtotal.toStringAsFixed(2)}'),
                              _buildTableRow(
                                  'GST (${gstPercent.toStringAsFixed(0)}%):',
                                  '₹${gstAmount.toStringAsFixed(2)}'),
                            ],
                          ),
                          const Divider(color: Colors.black54),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Price:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text('₹${totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pay Now Button (full width)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Add your payment logic here
                      },
                      child: const Text(
                        'Pay Now',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
