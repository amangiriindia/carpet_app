import 'package:OACrugs/screens/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/login/sign_up_page_image.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Image
                Image.asset(
                  'assets/login/welcome.png',
                  width: 450,
                  height: 450,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Text
                      const Text(
                        'Where Dreams Become Rugs',
                        style: AppStyles.headingTextStyle
                      ),
                      const Text(
                        'Create Your Unique Carpet.\nSign In to Start Designing.',
                        textAlign: TextAlign.left,
                        style: AppStyles.secondaryBodyTextStyle,
                      ),
                      const SizedBox(height: 20), // Spacing between the texts and buttons
                      // Buttons
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [



                          Container(
                            width: 352,
                            height: 42,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppStyles.primaryColorStart, AppStyles.primaryColorEnd],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x1C000000), // Shadow color with transparency
                                  offset: const Offset(0, 4), // Offset to cast shadow below the button
                                  blurRadius: 4, // Blur radius for shadow softness
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent, // Make button background transparent
                                shadowColor: Colors.transparent, // Remove button shadow (since we have it in the container)
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8), // Rectangular shape
                                ),
                              ),
                              onPressed: () {
                                // Navigate to Home page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                );
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontFamily: 'Poppins', // Font family
                                  fontSize: 14.51, // Font size
                                  fontWeight: FontWeight.w300, // Font weight
                                  height: 21.77 / 14.51, // Line height
                                  letterSpacing: 0.14, // Letter spacing
                                  color: Colors.white, // Set text color to white
                                ),
                              ),
                            ),
                          ),


                          const SizedBox(height: 16),
                          SizedBox(
                            width: 352,
                            height: 42,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFFFFF), // Button background color (white)
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8), // Rectangular shape with rounded corners
                                  side: const BorderSide(
                                    color: Color(0xFF000000), // Border color (black)
                                    width: 0.91, // Border width
                                  ),
                                ),
                              ),
                              onPressed: () {
                                // Navigate to Sign Up page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontFamily: 'Poppins', // Font family
                                  fontSize: 14.51, // Font size
                                  fontWeight: FontWeight.w300, // Font weight
                                  height: 21.77 / 14.51, // Line height
                                  letterSpacing: 0.14, // Letter spacing
                                  color: Colors.black, // Text color (black)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Bottom spacing to avoid overflow
              ],
            ),
          ),
        ],
      ),
    );
  }
}
