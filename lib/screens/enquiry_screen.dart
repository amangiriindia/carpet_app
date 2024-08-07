import 'package:OACrugs/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/color_picker.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_navigation_bar.dart';
import '../widgets/profile_drawer.dart';
import 'notification_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';

class EnquiryScreen extends StatelessWidget {
  const EnquiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorPickerProvider = Provider.of<ColorPickerProvider>(context, listen: false);

    // Load image and extract colors after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ImageProvider imageProvider = AssetImage('assets/products/product_1.png');
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
                child: Text('Persian Tabriz', style: TextStyle(fontSize: 20)),
              ),
              Image.asset(
                'assets/products/product_1.png',
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
                        title: Text('Colour Picker', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (int i = 0; i < colorPickerProvider.originalColors.length; i++)
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('#Shade ${i + 1}', style: TextStyle(fontSize: 16)),
                                            Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: colorPickerProvider.getAdjustedColor(i),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text('Hue'),
                                        Slider(
                                          value: colorPickerProvider.hues[i],
                                          onChanged: (value) {
                                            colorPickerProvider.updateHue(i, value);
                                          },
                                          min: 0.0,
                                          max: 360.0,
                                          label: 'Hue',
                                          activeColor: HSVColor.fromAHSV(1, colorPickerProvider.hues[i], 1, 1).toColor(),
                                        ),
                                        SizedBox(height: 8),
                                        Text('Opacity'),
                                        Slider(
                                          value: colorPickerProvider.opacities[i],
                                          onChanged: (value) {
                                            colorPickerProvider.updateOpacity(i, value);
                                          },
                                          min: 0.0,
                                          max: 1.0,
                                          label: 'Opacity',
                                        ),
                                      ],
                                    ),
                                  ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Handle submit action
                                    },
                                    child: Text('Submit'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Product Details'),
                        children: [
                          ListTile(
                            title: Text('Serial Number'),
                            subtitle: Text('65228'),
                          ),
                          ListTile(
                            title: Text('Dimension'),
                            subtitle: Text('151 x 102 cm'),
                          ),
                          ListTile(
                            title: Text('Quality'),
                            subtitle: Text('Hand-knotted'),
                          ),
                          ListTile(
                            title: Text('Material'),
                            subtitle: Text('Wool & silk on silk base'),
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
                pageBuilder: (_, __, ___) => const SearchScreen(),
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
