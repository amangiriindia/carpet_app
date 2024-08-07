import 'package:OACrugs/screens/search_screen.dart';
import 'package:OACrugs/screens/thanks_screen.dart';
import 'package:OACrugs/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/color_picker.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_navigation_bar.dart';
import '../widgets/profile_drawer.dart';
import 'home_screen.dart';
import 'notification_screen.dart';

class EnquiryFormScreen extends StatelessWidget {
  const EnquiryFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const NotificationScreen(),
      endDrawer: const ProfileDrawer(),
      body: EnquiryForm(), // Use the EnquiryForm widget defined previously
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

class EnquiryForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Enquiry Form',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 12),
                Image.asset(
                  'assets/products/product_1.png', // Replace with your image URL
                  width: 200,
                  height: 180,
                ),
                SizedBox(height: 10),
                Text(
                  'Persian Tabriz',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black, // Text color
                    side: BorderSide(color: Colors.black), // Border color
                    backgroundColor: Colors.white, // Background color
                    fixedSize: Size(80, 30), // Set the size to make it rectangular
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Ensure square corners
                  ),
                  child: Center(child: Text('Edit', style: TextStyle(fontSize: 14))),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          CustomTextField(label: 'Full Name', hint: 'Enter Name'),
          CustomTextField(label: 'Email', hint: 'Enter Email'),
          CustomTextField(label: 'Phone No.', hint: '+91 -----------'),
          CustomTextField(label: 'Address', hint: 'Enter Address'),
          CustomTextField(label: 'Expected Delivery on', hint: 'DD-MM-YYYY'),
          CustomTextField(label: 'Query', hint: 'Enter Query'),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ThankYouScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                fixedSize: Size(165, 36), // Fixed width button
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Ensure square corners
              ),
              child: Text('Submit Request', style: TextStyle(fontSize: 12, color: Colors.white)), // White text
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;

  CustomTextField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              border: UnderlineInputBorder(), // Only underline border
              contentPadding: EdgeInsets.symmetric(vertical: 8), // Adjust padding to match the image
            ),
          ),
        ],
      ),
    );
  }
}
