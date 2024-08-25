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
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14),
                    child: IconButton(
                      icon: const Icon(Icons.login_outlined, color:AppStyles.secondaryTextColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 80),
                  const Icon(Icons.info_outline, color: AppStyles.primaryTextColor),
                  const SizedBox(width: 4),
                  const Text(
                    'About Us',
                    style: AppStyles.headingTextStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Our Story',
              style:AppStyles.primaryBodyTextStyle
            ),
            const SizedBox(height: 10),

            // About Us Content (Placeholder Text)
            const Text(
              'At OACrugs, we believe that a rug is more than just a floor covering; it\'s a piece of art that tells a story and adds warmth to your home. We are passionate about crafting high-quality, handcrafted rugs that blend traditional techniques with contemporary designs.',
              style: AppStyles.secondaryBodyTextStyle,
              ),

            const SizedBox(height: 10),

            const Text(
              'Our journey began with a love for the artistry and craftsmanship behind every rug. We work closely with skilled artisans who pour their heart and soul into each creation, ensuring that every rug is a unique masterpiece.',
              style: AppStyles.secondaryBodyTextStyle,
            ),
            const SizedBox(height: 10),

            const Text(
              'We are committed to using sustainable materials and ethical practices, ensuring that our rugs are not only beautiful but also kind to the planet and its people.',
                style: AppStyles.secondaryBodyTextStyle,
            ),

            // Add more sections as needed (e.g., Our Mission, Our Team, etc.)
          ],
        ),
      ),
    );
  }
}