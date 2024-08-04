import 'package:carpet_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:carpet_app/screens/address_screen.dart';
import 'package:carpet_app/screens/approved_query.dart';
import 'package:carpet_app/screens/order_screen.dart';
import 'package:carpet_app/screens/pending_query.dart';
import '../screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../splash_screen/custom_splash_screen.dart'; // Import shared_preferences

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 120, bottom: 50),
            color: Colors.white10,
            child: const Center(
              child: Text(
                'Profile',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            leading: const Icon(Icons.mode_edit_outline_outlined, size: 24),
            title: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16),
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
              style: TextStyle(fontSize: 16),
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
              style: TextStyle(fontSize: 16),
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
              style: TextStyle(fontSize: 16),
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
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ApprovedQueryScreen(),
              ));
            },
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            leading: const Icon(Icons.logout, size: 24),
            title: const Text(
              'Log Out',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('isLoggedIn'); // Clear login status
              // Optionally clear other data
              await prefs.remove('phoneNumber');
              await prefs.remove('email');
              await prefs.remove('password');

              // Navigate to the splash screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            },
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
