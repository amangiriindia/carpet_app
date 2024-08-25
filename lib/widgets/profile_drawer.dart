import 'package:OACrugs/const.dart';
import 'package:OACrugs/screens/pending_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../screens/address_screen.dart';
import '../screens/approved_query.dart';
import '../screens/order_screen.dart';
import '../screens/pageutill/about_us_screen.dart';
import '../screens/pageutill/custmer_support_screen.dart';
import '../screens/pageutill/home_title_heading.dart';
import '../screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/welcome_screen.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  void _navigateWithLoading(BuildContext context, Widget page) async {
    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SpinKitFadingCircle(
            size: 50.0,
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isOdd ? AppStyles.primaryColorStart : AppStyles.primaryColorEnd,
                ),
              );
            },
          ),
        );
      },
    );

    // Wait for 2 seconds before navigating
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to the new page
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => page,
    )).then((_) {
      // Dismiss the loading dialog after navigation is complete
      Navigator.of(context).pop();
    });
  }

  Future<void> _confirmLogout(BuildContext context) async {
    // Show a confirmation dialog
    bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppStyles.backgroundPrimary,
          title: const Text('Confirm Logout', style: AppStyles.headingTextStyle,),
          content: const Text('Do you want to log out?', style: AppStyles.primaryBodyTextStyle,),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel', style: AppStyles.primaryBodyTextStyle,),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout', style: AppStyles.primaryBodyTextStyle,),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Show the loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: SpinKitFadingCircle(
              size: 50.0,
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isOdd ? AppStyles.primaryColorStart : AppStyles.primaryColorEnd,
                  ),
                );
              },
            ),
          );
        },
      );

      // Proceed with the logout process
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Wait for the loading spinner to be displayed before navigating
      await Future.delayed(const Duration(seconds: 2));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

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
              _navigateWithLoading(context, const EditProfileScreen());
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
              _navigateWithLoading(context, const AddressScreen());
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
              _navigateWithLoading(context, const OrderScreen());
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
              _navigateWithLoading(context, const PendingOueryScreen());
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
              _navigateWithLoading(context, const ApprovedQueryScreen());
            },
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            leading: const Icon(Icons.headset_mic_outlined, size: 24),
            title: const Text(
              'Customer Support',
              style: AppStyles.primaryBodyTextStyle,
            ),
            onTap: () {
              _navigateWithLoading(context, const CustomerSupportScreen());
            },
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            leading: const Icon(Icons.info_outline, size: 24),
            title: const Text(
              'About Us',
              style: AppStyles.primaryBodyTextStyle,
            ),
            onTap: () {
              _navigateWithLoading(context, const AboutUsScreen());
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
            onTap: () {
              _confirmLogout(context);
            },
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
