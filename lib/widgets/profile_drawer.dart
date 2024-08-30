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




class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isAppBarCollapsed = false;

  void _navigateWithLoading(BuildContext context, Widget page) async {
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

    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => page,
    )).then((_) {
      Navigator.of(context).pop();
    });
  }

  Future<void> _confirmLogout(BuildContext context) async {
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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      await Future.delayed(const Duration(seconds: 2));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo is ScrollUpdateNotification) {
            setState(() {
              _isAppBarCollapsed = scrollInfo.metrics.pixels > 200;
            });
          }
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 350,
              flexibleSpace: FlexibleSpaceBar(
                background: _TopPortion(), // Use your existing `_TopPortion` widget
                title: _isAppBarCollapsed
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8),
                    const Text("My Profile"),
                  ],
                )
                    : null,
                centerTitle: false,
                collapseMode: CollapseMode.parallax,
              ),
              pinned: true,
              floating: true,
              snap: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Divider(),
                        _SectionHeader(text: 'Profile & Settings'),
                        _ProfileOptionItem(
                          icon: Icons.mode_edit_outline_outlined,
                          text: 'Edit Profile',
                          onTap: () {
                            _navigateWithLoading(context, const EditProfileScreen());
                          },
                        ),
                        _ProfileOptionItem(
                          icon: Icons.location_on_outlined,
                          text: 'Address',
                          onTap: () {
                            _navigateWithLoading(context, const AddressScreen());
                          },
                        ),
                        _ProfileOptionItem(
                          icon: Icons.shopping_bag_outlined,
                          text: 'Orders',
                          onTap: () {
                            _navigateWithLoading(context, const OrderScreen());
                          },
                        ),
                        _ProfileOptionItem(
                          icon: Icons.notes_outlined,
                          text: 'Pending Query',
                          onTap: () {
                            _navigateWithLoading(context, const PendingOueryScreen());
                          },
                        ),
                        _ProfileOptionItem(
                          icon: Icons.done_all_outlined,
                          text: 'Approved Query',
                          onTap: () {
                            _navigateWithLoading(context, const ApprovedQueryScreen());
                          },
                        ),
                        _ProfileOptionItem(
                          icon: Icons.headset_mic_outlined,
                          text: 'Customer Support',
                          onTap: () {
                            _navigateWithLoading(context, const CustomerSupportScreen());
                          },
                        ),
                        _ProfileOptionItem(
                          icon: Icons.info_outline,
                          text: 'About Us',
                          onTap: () {
                            _navigateWithLoading(context, const AboutUsScreen());
                          },
                        ),
                        _ProfileOptionItem(
                          icon: Icons.logout,
                          text: 'Logout',
                          onTap: () {
                            _confirmLogout(context);
                          },
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopPortion extends StatelessWidget {
  // Assuming this widget displays the user's profile picture and other info
  @override
  Widget build(BuildContext context) {
    // Your implementation for the top portion of the profile page
    return Container(
      color: Colors.blue,
      child: Center(
        child: Column(
          children: [
            // Add profile image, name, etc.
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;

  const _SectionHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: AppStyles.headingTextStyle,
      ),
    );
  }
}

class _ProfileOptionItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ProfileOptionItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: Icon(icon, size: 24),
      title: Text(text, style: AppStyles.primaryBodyTextStyle),
      onTap: onTap,
    );
  }
}

