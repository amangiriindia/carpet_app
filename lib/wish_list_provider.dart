import 'package:flutter/material.dart';

class WishListProvider with ChangeNotifier {
  final List<WishListItem> _items = [];

  List<WishListItem> get items => _items;

  void addItem(WishListItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(WishListItem item) {
    _items.remove(item);
    notifyListeners();
  }

  bool isInWishList(WishListItem item) {
    return _items.contains(item);
  }
}

class WishListItem {
  final String id;
  final String imagePath;
  final String name;
  final double price;
  final String size;

  WishListItem({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.price,
    required this.size,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WishListItem &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}
