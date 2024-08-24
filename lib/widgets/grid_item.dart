import 'package:flutter/material.dart';
import '../const.dart';
import '../screens/search_screen.dart';

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
                    onPressed: onLikeToggle,
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
