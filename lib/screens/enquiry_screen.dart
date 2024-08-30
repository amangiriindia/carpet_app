import 'package:OACrugs/screens/pageutill/search_home_page.dart';
import 'package:OACrugs/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/color_picker.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_navigation_bar.dart';
import '../../widgets/profile_drawer.dart';
import 'package:OACrugs/screens/wishlist_screen.dart'; // Correct import statement
import 'dart:typed_data';

import 'home_screen.dart';
import 'notification_screen.dart'; // Import for Uint8List

class EnquiryScreen extends StatelessWidget {
  final String carpetId;
  final String patternId;
  final String carpetName;
  final Uint8List patternImage;
  final List<String> hexCodes;
  final String shapeId;
  final String dimensionId;
  final String addressId;
  final String quantity;
  final DateTime? expectedDeliveryDate;
  final String query;

  const EnquiryScreen({
    super.key,
    required this.carpetId,
    required this.patternId,
    required this.carpetName,
    required this.patternImage,
    required this.hexCodes,
    required this.shapeId,
    required this.dimensionId,
    required this.addressId,
    required this.quantity,
    this.expectedDeliveryDate,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final colorPickerProvider = Provider.of<ColorPickerProvider>(context, listen: false);

    // Load image and extract colors after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ImageProvider imageProvider = MemoryImage(patternImage); // Use the pattern image from previous page
      await colorPickerProvider.extractColorsFromImage(imageProvider);
    });

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const NotificationScreen(),
      endDrawer: const ProfileDrawer(),
      body: Consumer<ColorPickerProvider>(
        builder: (context, colorPickerProvider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(carpetName, style: TextStyle(fontSize: 20)),
              ),
              Image.memory(
                patternImage,
                height: 250,
                width: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
              const Divider(indent: 20, endIndent: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpansionTile(
                        title: Text('Product Details'),
                        children: [
                          ListTile(
                            title: Text('Serial Number'),
                            subtitle: Text(carpetId),
                          ),
                          ListTile(
                            title: Text('Dimension'),
                            subtitle: Text(dimensionId), // Show selected dimension
                          ),
                          ListTile(
                            title: Text('Quality'),
                            subtitle: Text('Hand-knotted'), // Example data
                          ),
                          ListTile(
                            title: Text('Material'),
                            subtitle: Text('Wool & silk on silk base'), // Example data
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Care & Maintenance'),
                        children: [
                          ListTile(
                            title: Text('Details'),
                            subtitle: Text('Some details about care and maintenance'),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Disclaimer'),
                        children: [
                          ListTile(
                            title: Text('Details'),
                            subtitle: Text('Some disclaimer details'),
                          ),
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/enquiry_form');
                            },
                            child: Text('Enquiry'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2, // Set the appropriate index for the Enquiry form screen
        onTap: (index) {
          // Handle navigation based on index
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HomeScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const SearchHomePage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const WishListScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
      ),
    );
  }
}
