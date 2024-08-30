import 'package:flutter/material.dart';
import '../const.dart';
import '../screens/search_screen.dart';



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Container(
        color: AppStyles.backgroundSecondry,
        child: Image.asset(
          'assets/logos/center_image.png',
          height: 70.0,
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: AppStyles.backgroundSecondry,
          size: 30.0,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notification_important_sharp,
            color: AppStyles.backgroundSecondry,
            size: 30.0,
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppStyles.primaryColorEnd, AppStyles.primaryColorStart],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: Container(
              height: 45.0,
              decoration: BoxDecoration(
                color: AppStyles.backgroundSecondry,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  const Expanded(
                    child: Text(
                      'Search...',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100.0);
}




class CustomNormalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomNormalAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0), // Adjust vertical padding here
        child: Container(
          color: AppStyles.backgroundSecondry,
          child: Image.asset(
            'assets/logos/center_image.png',
            height: 90.0,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: AppStyles.backgroundSecondry,
          size: 30.0,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notification_important_sharp,
            color: AppStyles.backgroundSecondry,
            size: 30.0,
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppStyles.primaryColorEnd, AppStyles.primaryColorStart],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65.0);
}



