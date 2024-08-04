import 'package:flutter/material.dart';

import 'collections.dart';

class ShopsToExploreList extends StatelessWidget {
  final double width; // Add a width parameter

  // Constructor to accept width
  ShopsToExploreList({required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Container(
        height: 165.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Container(
              width: width, // Use the width parameter
              child: HorizontalImageItem(
                imagePath: 'assets/login/welcome.png',
                text: 'Trendy Boutiques', onTap: () {
                Navigator.pushNamed(
                  context,
                  '/collection_screen',
                  arguments: {'selectedIndex': 3},
                );
              },
              ),
            ),
            Container(
              width: width, // Use the width parameter
              child: HorizontalImageItem(
                imagePath: 'assets/login/welcome.png',
                text: 'Vintage Shops', onTap: () {
                Navigator.pushNamed(
                  context,
                  '/collection_screen',
                  arguments: {'selectedIndex': 3},
                );
              },
              ),
            ),
            Container(
              width: width, // Use the width parameter
              child: HorizontalImageItem(
                imagePath: 'assets/login/welcome.png',
                text: 'Artisanal Stores', onTap: () {
                Navigator.pushNamed(
                  context,
                  '/collection_screen',
                  arguments: {'selectedIndex': 3},
                );
              },
              ),
            ),
            Container(
              width: width, // Use the width parameter
              child: HorizontalImageItem(
                imagePath: 'assets/login/welcome.png',
                text: 'Luxury Brands', onTap: () {
                Navigator.pushNamed(
                  context,
                  '/collection_screen',
                  arguments: {'selectedIndex': 3},
                );
              },
              ),
            ),
            Container(
              width: width, // Use the width parameter
              child: HorizontalImageItem(
                imagePath: 'assets/login/welcome.png',
                text: 'Handmade Goods', onTap: () {
                Navigator.pushNamed(
                  context,
                  '/collection_screen',
                  arguments: {'selectedIndex': 3},
                );
              },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
