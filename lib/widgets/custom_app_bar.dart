import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Stack(
          children: [
            Icon(
              Icons.notifications_none, // Outlined bell icon
              color: Colors.black,
              size: 30.0,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                Icons.circle,
                color: Colors.red,
                size: 8.0, // Size of the red dot
              ),
            ),
          ],
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.person,
            color: Colors.black,
            size: 30.0,
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer(); // Open the drawer
          },
        ),
      ],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
