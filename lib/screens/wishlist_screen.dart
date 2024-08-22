import 'dart:convert';
import 'dart:typed_data';
import 'package:OACrugs/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../const.dart';
import '../widgets/grid_item.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishListScreen> {
  List<CollectionItem> _wishlistItems = [];

  @override
  void initState() {
    super.initState();
    _loadWishlistItems();
  }
  Future<void> _loadWishlistItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? likedItemIds = prefs.getStringList('liked_items');

      print('Liked item IDs from SharedPreferences: $likedItemIds'); // Debugging

      if (likedItemIds != null && likedItemIds.isNotEmpty) {
        try {
          // Fetch item details for each liked item
          List<CollectionItem> items = await Future.wait(
            likedItemIds.map((id) => _fetchItemById(id)),
          );
          setState(() {
            _wishlistItems = items;
          });
        } catch (fetchError) {
          print('Error fetching wishlist items (inner catch): $fetchError');
          // Show a more specific error message if possible
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error fetching wishlist items.')),
          );
        }
      }
    } catch (error) {
      print('Error loading wishlist items (outer catch): $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading wishlist. Please try again later.')),
      );
    }
  }

  Future<CollectionItem> _fetchItemById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${APIConstants.API_URL}/api/v1/carpet/$id'),
      );

      print('Fetch item by ID response status code: ${response.statusCode}');
      print('Fetch item by ID response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Check if the 'photo' data exists and has the expected structure
        if (jsonResponse['photo'] != null &&
            jsonResponse['photo']['data'] != null &&
            jsonResponse['photo']['data']['data'] != null) {

          List<int> imageData = List<int>.from(jsonResponse['photo']['data']['data']);
          return CollectionItem(
            imageData: Uint8List.fromList(imageData),
            text: jsonResponse['name'],
            price: jsonResponse['price'].toString(),
            id: jsonResponse['_id'],
          );
        } else {
          // Handle the case where 'photo' data is missing or has an unexpected structure
          throw Exception('Invalid photo data in response');
        }
      } else {
        throw Exception('Failed to load item by id: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching item by id: $error');
      rethrow;
    }
  }



  Future<void> _toggleLike(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> likedItemIds = prefs.getStringList('liked_items') ?? [];

      if (likedItemIds.contains(id)) {
        likedItemIds.remove(id);
        _wishlistItems.removeWhere((item) => item.id == id);
      } else {
        likedItemIds.add(id);
        final newItem = await _fetchItemById(id);
        setState(() {
          _wishlistItems.add(newItem);
        });
      }

      await prefs.setStringList('liked_items', likedItemIds);
      setState(() {});
    } catch (error) {
      print('Error toggling like: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Wishlist'),
          backgroundColor: Colors.deepPurple,
        ),
        body: _wishlistItems.isEmpty
            ? const Center(
          child: Text('No items in wishlist'),
        )
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: _wishlistItems.length,
            itemBuilder: (context, index) {
              final item = _wishlistItems[index];
              return GridItem(
                item: item,
                onTap: () {
                  // Handle item tap
                },
                onLikeToggle: () => _toggleLike(item.id),
                isLiked: true,
              );
            },
          ),
        ),
      ),
    );
  }
}
