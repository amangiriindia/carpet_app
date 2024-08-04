import 'package:carpet_app/screens/home_screen.dart';
import 'package:carpet_app/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  // Texts above buttons
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2), // Spacing between the texts
                  const Text(
                    'Our Personalized Carpet Design Destination\nLogin to Your Account',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                    ),
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
                          gradient: const LinearGradient(
                            begin: Alignment(-0.67, -1.0),
                            end: Alignment(1.0, 1.91),
                            colors: [Color(0xFF000000), Color(0xFF666666)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // Make button background transparent
                            shadowColor: Colors.transparent, // Remove button shadow
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
                          child: const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 352,
                        height: 42,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white, // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Rectangular shape
                              side: const BorderSide(
                                  color: Colors.black), // Border color
                            ),
                          ),
                          onPressed: () {
                            // Navigate to Sign Up page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpScreen()),
                            );
                          },
                          child: const Text('Sign Up'),
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
    );
  }
}
