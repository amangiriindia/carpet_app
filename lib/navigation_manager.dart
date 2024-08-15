import 'package:OACrugs/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:OACrugs/screens/home_screen.dart';
import 'package:OACrugs/screens/search_screen.dart';
import 'package:OACrugs/screens/wishlist_screen.dart';

class NavigationManager extends StatefulWidget {
  @override
  _NavigationManagerState createState() => _NavigationManagerState();
}

class _NavigationManagerState extends State<NavigationManager> {
  int _selectedIndex = 0;

  // List of screens to display
  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    WishListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
