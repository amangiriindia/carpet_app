import 'package:flutter/material.dart';

class HorizontalImageList extends StatefulWidget {
  const HorizontalImageList({super.key});

  @override
  _HorizontalImageListState createState() => _HorizontalImageListState();
}

class _HorizontalImageListState extends State<HorizontalImageList> {
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

class HorizontalImageItem extends StatefulWidget {
  final String imagePath;
  final String text;
  final VoidCallback onTap;

  HorizontalImageItem({
    required this.imagePath,
    required this.text,
    required this.onTap,
  });

  @override
  _HorizontalImageItemState createState() => _HorizontalImageItemState();
}

class _HorizontalImageItemState extends State<HorizontalImageItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        width: 110.0, // Set width to 110px
        height: 110.0, // Set height to 110px
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0), // Adjust border radius as needed
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                widget.imagePath, // Image path
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withOpacity(0.3), // Semi-transparent background color
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(5.0), // Adjust padding as needed
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6), // Background color of the box
                      border: Border.all(color: Colors.white, width: 1), // White border
                      borderRadius: BorderRadius.circular(5.0), // Rounded corners
                    ),
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.0, // Adjust text size as needed
                      ),
                      textAlign: TextAlign.center, // Center align text
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
