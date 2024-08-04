import 'package:flutter/material.dart';
import 'package:carpet_app/screens/collection_screen.dart';
import 'package:carpet_app/screens/home_screen.dart';
import 'package:carpet_app/screens/search_screen.dart';
import 'package:carpet_app/screens/wishlist_screen.dart';

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
    CollectionScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            label: 'Collection',
          ),
        ],
      ),
    );
  }
}
