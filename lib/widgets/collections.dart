import 'package:flutter/material.dart';

class HorizontalImageList extends StatelessWidget {
  const HorizontalImageList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Container(
        height: 150.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            HorizontalImageItem(
              imagePath: 'assets/login/welcome.png',
              text: 'Modern Marvels',
              onTap: () {
                // Handle the tap event for "Modern Marvels"
                Navigator.pushNamed(
                  context,
                  '/collection_screen',
                  arguments: {'selectedIndex': 3},
                );
              },
            ),
            HorizontalImageItem(
              imagePath: 'assets/login/welcome.png',
              text: 'Classic Elegance',
              onTap: () {
                // Handle the tap event for "Classic Elegance"
                Navigator.pushNamed(
                  context,
                  '/collection_screen',
                  arguments: {'selectedIndex': 3},
                );
              },
            ),
            HorizontalImageItem(
              imagePath: 'assets/login/welcome.png',
              text: 'Bohemian Bliss',
              onTap: () {
                // Handle the tap event for "Bohemian Bliss"
                Navigator.pushNamed(
                  context,
                  '/collection_screen',
                  arguments: {'selectedIndex': 3},
                );
              },
            ),
            HorizontalImageItem(
              imagePath: 'assets/login/welcome.png',
              text: 'Nature\'s Harmony',
              onTap: () {
                // Handle the tap event for "Nature's Harmony"
                Navigator.pushNamed(
                  context,
                  '/collection_screen',
                  arguments: {'selectedIndex': 3},
                );
              },
            ),
            HorizontalImageItem(
              imagePath: 'assets/login/welcome.png',
              text: 'Modern Marvels',
              onTap: () {
                // Handle the tap event for "Modern Marvels"
                Navigator.pushNamed(
                  context,
                  '/collection_screen',
                  arguments: {'selectedIndex': 3},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalImageItem extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onTap;

  HorizontalImageItem({
    required this.imagePath,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        width: 110.0, // Set width to 91px
        height: 110.0, // Set height to 110px
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0), // Adjust border radius as needed
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imagePath, // Image path
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withOpacity(0.2), // Adjust transparency here
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(6.0), // Adjust padding as needed
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1), // White border
                    ),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0, // Adjust text size as needed
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
