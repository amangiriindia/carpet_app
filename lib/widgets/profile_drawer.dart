
import 'package:OACrugs/const.dart';
import 'package:OACrugs/screens/pending_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/address_screen.dart';
import '../screens/approved_query.dart';
import '../screens/order_screen.dart';
import '../screens/pageutill/about_us_screen.dart';
import '../screens/pageutill/custmer_support_screen.dart';
import '../screens/pageutill/home_title_heading.dart';
import '../screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/welcome_screen.dart';
import '../splash_screen/custom_splash_screen.dart'; // Import shared_preferences

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppStyles.backgroundPrimary,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[

          const Padding(
            padding: EdgeInsets.only(top: 70.0), // Adjust the value to your needs
            child: SectionTitle(title: "Profile"),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            leading: const Icon(Icons.mode_edit_outline_outlined, size: 24),
            title: const Text(
              'Edit Profile',
              style: AppStyles.primaryBodyTextStyle,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const EditProfileScreen(),
              ));
            },
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            leading: const Icon(Icons.location_on_outlined, size: 24),
            title: const Text(
              'Address',
              style: AppStyles.primaryBodyTextStyle,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddressScreen(),
              ));
            },
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            leading: const Icon(Icons.shopping_bag_outlined, size: 24),
            title: const Text(
              'Orders',
              style: AppStyles.primaryBodyTextStyle,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const OrderScreen(),
              ));
            },
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            leading: const Icon(Icons.notes_outlined, size: 24),
            title: const Text(
              'Pending Query',
              style: AppStyles.primaryBodyTextStyle,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PendingOueryScreen(),
              ));
            },
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            leading: const Icon(Icons.done_all_outlined, size: 24),
            title: const Text(
              'Approved Query',
              style: AppStyles.primaryBodyTextStyle,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ApprovedQueryScreen(),
              ));
            },
          ),
          const Divider(height: 1),

          ListTile( // New Customer Support ListTile
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            leading: const Icon(Icons.headset_mic_outlined, size: 24),
            title: const Text(
              'Customer Support',
              style: AppStyles.primaryBodyTextStyle,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CustomerSupportScreen(),
              ));
            },
          ),
          const Divider(height: 1),
          ListTile( // New About Us ListTile
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            leading: const Icon(Icons.info_outline, size: 24),
            title: const Text(
              'About Us',
              style: AppStyles.primaryBodyTextStyle,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AboutUsScreen(),
              ));
            },
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            leading: const Icon(Icons.logout, size: 24),
            title: const Text(
              'Log Out',
              style: AppStyles.primaryBodyTextStyle,
            ),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              // Clear all stored data
              await prefs.clear();
              // Navigate to the splash screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) =>WelcomeScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
