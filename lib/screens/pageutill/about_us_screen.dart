import 'package:flutter/material.dart';

import '../../const.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/profile_drawer.dart';
import '../notification_screen.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      drawer: const NotificationScreen(),
      endDrawer: const ProfileDrawer(),
      body: SingleChildScrollView( // Allow scrolling if content overflows
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Container(
              color: AppStyles.backgroundSecondry,
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14),
                    child: IconButton(
                      icon: const Icon(Icons.login_outlined, color: Colors.black54),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 80),
                  const Icon(Icons.list_alt_outlined, color: Colors.black54),
                  const SizedBox(width: 4),
                  const Text(
                    'About Us',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const Text(
              'Our Story',
              style: TextStyle(
                fontFamily: 'Pumpkin', // Apply Pumpkin font
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // About Us Content (Placeholder Text)
            const Text(
              'At OACrugs, we believe that a rug is more than just a floor covering; it\'s a piece of art that tells a story and adds warmth to your home. We are passionate about crafting high-quality, handcrafted rugs that blend traditional techniques with contemporary designs.',
              style: TextStyle(
                fontFamily: 'Pumpkin',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Our journey began with a love for the artistry and craftsmanship behind every rug. We work closely with skilled artisans who pour their heart and soul into each creation, ensuring that every rug is a unique masterpiece.',
              style: TextStyle(
                fontFamily: 'Pumpkin',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'We are committed to using sustainable materials and ethical practices, ensuring that our rugs are not only beautiful but also kind to the planet and its people.',
              style: TextStyle(
                fontFamily: 'Pumpkin',
                fontSize: 16,
              ),
            ),

            // Add more sections as needed (e.g., Our Mission, Our Team, etc.)
          ],
        ),
      ),
    );
  }
}