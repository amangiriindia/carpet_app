import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../wish_list_provider.dart';

class GridItem extends StatelessWidget {
  final WishListItem item;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const GridItem({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(5.0)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Image.memory(
                    item.imagePath,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹ ${item.price}',
                          style: const TextStyle(fontSize: 12.0),
                        ),
                        Text(
                          item.size,
                          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border),
                    color: isFavorite ? Colors.red : Colors.black,
                    onPressed: onFavoriteToggle,
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
