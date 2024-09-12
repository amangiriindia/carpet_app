import 'package:flutter/material.dart';
import '../../components/custom_app_bar.dart';
import 'custom_navigation_bar.dart';
import 'profile_drawer.dart';
import 'notification_screen.dart';


class BaseScreen extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final Widget child;

  const BaseScreen({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const NotificationScreen(),
      drawer: const ProfileDrawer(),
      body: child,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
      ),
    );
  }
}
