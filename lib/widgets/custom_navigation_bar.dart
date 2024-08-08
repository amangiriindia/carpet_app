import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        for (int i = 0; i < 3; i++)
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 50,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ImageIcon(
                      AssetImage(i == 0
                          ? 'assets/image/navbar_home_icon.png'
                          : i == 1
                          ? 'assets/image/navbar_search_icon.png'
                          : 'assets/image/navbar_like_icon.png'),
                      color: currentIndex == i ? Colors.black : Colors.grey, // Corrected color logic
                    ),
                  ),
                  if (currentIndex == i) // Corrected hover icon condition
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Image.asset('assets/image/buttom_navbar_hover.png'),
                    ),
                ],
              ),
            ),
            label: '',
          ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.black, // You can remove these since color is handled manually
      unselectedItemColor: Colors.grey,
    );
  }
}
