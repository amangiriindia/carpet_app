import 'package:OACrugs/const.dart';
import 'package:OACrugs/screens/pageutill/search_home_page.dart';
import 'package:OACrugs/screens/search_screen.dart';
import 'package:OACrugs/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_navigation_bar.dart';
import 'home_screen.dart'; // Import the HomeScreen

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundPrimary,
      appBar: CustomAppBar(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2, // Set the appropriate index for the Thank You screen
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Thank You !',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: AppStyles.primaryFontFamily,
                color: AppStyles.primaryColorStart, // Custom color
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We appreciate your inquiry.\nOur team will be in touch soon!',
              style:AppStyles.secondaryBodyTextStyle,
            ),
            SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const HomeScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xFFA80038), // Custom color for text and border
                side: BorderSide(color: Color(0xFFA80038)), // Custom color for border
                backgroundColor: Colors.white,
                fixedSize: Size(200, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: Text(
                'Continue Exploring',
                style: TextStyle(fontSize: 14,
                fontFamily: AppStyles.primaryFontFamily,
                  
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
