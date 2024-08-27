import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../const.dart';


// Wishlist class to manage liked items
class WishlistHandle {
  // Static list to store liked items
  static List<CollectionItem> _wishlistItems = [];

  // Method to add an item to the wishlist
  static void addItem(CollectionItem item) {
    if (!_wishlistItems.contains(item)) {
      _wishlistItems.add(item);
    }
  }

  // Method to remove an item from the wishlist
  static void removeItem(CollectionItem item) {
    _wishlistItems.remove(item);
  }

  // Method to check if an item is in the wishlist
  static bool isItemInWishlist(CollectionItem item) {
    return _wishlistItems.contains(item);
  }

  // Method to get the list of all wishlist items
  static List<CollectionItem> get wishlistItems => _wishlistItems;
}

class GridItem extends StatelessWidget {
  final CollectionItem item;
  final VoidCallback onTap;
  final VoidCallback onLikeToggle;
  final bool isLiked;

  const GridItem({
    required this.item,
    required this.onTap,
    required this.onLikeToggle,
    required this.isLiked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Use onTap for navigation
      hoverColor: Colors.grey[200],
      child: Card(
        color: AppStyles.backgroundPrimary,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 2.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                  child: Image.memory(
                    item.imageData,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150.0,
                  ),
                ),
                Positioned(
                  right: 8.0,
                  top: 8.0,
                  child: IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.redAccent : Colors.grey[600],
                      size: 24.0,
                    ),
                    onPressed: () {
                      if (isLiked) {
                        WishlistHandle.removeItem(item);
                      } else {
                        WishlistHandle.addItem(item);
                      }
                      onLikeToggle();
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.text,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.primaryTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Price: ${item.price}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: AppStyles.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class CollectionItem {
  final Uint8List imageData;
  final String text;
  final String price;
  final String id;

  CollectionItem({
    required this.imageData,
    required this.text,
    required this.price,
    required this.id,
  });

  // Convert a CollectionItem instance to a map
  Map<String, dynamic> toJson() {
    return {
      'imageData': base64Encode(imageData), // Encode imageData as a base64 string
      'text': text,
      'price': price,
      'id': id,
    };
  }

  // Create a CollectionItem from a map
  factory CollectionItem.fromJson(Map<String, dynamic> json) {
    return CollectionItem(
      imageData: base64Decode(json['imageData']), // Decode base64 string to Uint8List
      text: json['text'],
      price: json['price'],
      id: json['id'],
    );
  }

  // Overriding == and hashCode to allow for proper comparison in Wishlist
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CollectionItem &&
        other.id == id &&
        other.text == text &&
        other.price == price &&
        other.imageData == imageData;
  }

  @override
  int get hashCode {
    return id.hashCode ^ text.hashCode ^ price.hashCode ^ imageData.hashCode;
  }
}

