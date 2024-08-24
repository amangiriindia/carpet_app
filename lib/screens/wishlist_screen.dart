import 'package:OACrugs/screens/pageutill/home_title_heading.dart';
import 'package:flutter/material.dart';

import '../const.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundSecondry,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center items horizontally
              children: [
                SectionTitle(title: "Wishlist"),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'No items in wishlist',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
