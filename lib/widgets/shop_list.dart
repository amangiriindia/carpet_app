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

            HorizontalImageList()
          ],
        ),
      ),
    );
  }
}
