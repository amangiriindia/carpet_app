import 'package:OACrugs/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../constant/const.dart';
import '../address_screen.dart';
import '../approved_query_screen.dart';
import '../order_screen.dart';
import '../about_us_screen.dart';
import '../custmer_support_screen.dart';
import '../profile_screen.dart';
import '../pending_query_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../splash_screen/custom_splash_screen.dart';


class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  late String _userId = '';
  late String _firstName = '';
  late String _lastName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '66c4aa81c3e37d9ff6c4be6c';
      _firstName = prefs.getString('firstName') ?? '';
      _lastName = prefs.getString('lastName') ?? '';
    });
  }

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
        MaterialPageRoute(builder: (context) => CustomSplashScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppStyles.backgroundPrimary,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppStyles.primaryColorEnd, AppStyles.primaryColorStart],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Text(
                    _firstName.isNotEmpty ? _firstName[0].toUpperCase() : '',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.primaryColorStart,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hello ${_firstName} ${_lastName}',
                      style: AppStyles.headingTextStyle.copyWith(color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        _navigateWithLoading(context, const EditProfileScreen());
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  leading: const Icon(Icons.home_outlined, size: 24),
                  title: const Text(
                    'Home',
                    style: AppStyles.primaryBodyTextStyle,
                  ),
                  onTap: () {
                    _navigateWithLoading(context, const HomeScreen());
                    // Navigate to Home Screen or handle it appropriately
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
                    'Logout',
                    style: AppStyles.primaryBodyTextStyle,
                  ),
                  onTap: () {
                    _confirmLogout(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
