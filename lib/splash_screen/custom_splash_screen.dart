import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import '../const.dart';
import '../screens/home_screen.dart';
import '../screens/pageutill/onboarding_screen.dart';
import '../screens/welcome_screen.dart';


class CustomSplashScreen extends StatefulWidget {
  @override
  _CustomSplashScreenState createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {


    // Initial delay before checking login status
    await Future.delayed(Duration(seconds: 2));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');


    // Navigate based on the login status
    if (isLoggedIn == true) {
      CommonFunction.showLoadingDialog(context);
      await Future.delayed(Duration(seconds: 1));
      CommonFunction.hideLoadingDialog(context);
      // Show loading dialog
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
      );
    } else {
      CommonFunction.showLoadingDialog(context);
      await Future.delayed(Duration(seconds: 1));
      CommonFunction.hideLoadingDialog(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingScreen(onDone: () {  },)),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.8, // Adjust the opacity value as needed (0.0 - 1.0)
              child: Image.asset(
                'assets/login/sign_up_page_image.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/logos/center_image.png',
              width: 187, // Set the specific width
              height: 187, // Set the specific height
            ),
          ),
        ],
      ),
    );
  }
}

