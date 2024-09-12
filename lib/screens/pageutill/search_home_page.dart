import 'dart:convert';
import 'dart:typed_data';

import 'package:OACrugs/screens/pageutill/wishlisthandle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/const.dart';
import 'package:OACrugs/screens/pageutill/carpet_pattern_choose.dart';

class SearchHomePage  extends StatefulWidget {
  const SearchHomePage({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchHomePage> {
  List<CollectionItem> _items = [];
  List<CollectionItem> _filteredItems = [];
  String _searchQuery = '';
  List<String> _likedItemIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLikedItems();
    _fetchCollections();
  }

  Future<void> _fetchCollections() async {
    try {
      final response = await http.get(
        Uri.parse('${APIConstants.API_URL}/api/v1/carpet/all-carpet'),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<dynamic> allCollections = jsonResponse['carpets'];
        List<CollectionItem> items = allCollections.map((collection) {
          List<int> imageData = List<int>.from(collection['photo']['data']['data']);
          return CollectionItem(
            imageData: Uint8List.fromList(imageData),
            text: collection['name'],
            price: '₹${collection['price']}',
            id: collection['_id'],
          );
        }).toList();
        setState(() {
          _items = items;
          _filteredItems = List.from(_items);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load collections');
      }
    } catch (error) {
      print('Error fetching collections: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadLikedItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _likedItemIds = prefs.getStringList('liked_items') ?? [];
      });
    } catch (error) {
      print('Error loading liked items: $error');
    }
  }

  void _search(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredItems = _items.where((item) {
        return item.text.toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        onChanged: _search,
        decoration: const InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildGridView() {
    if (_isLoading) {
      return CommonFunction.showLoadingIndicator();
    }

    if (_filteredItems.isEmpty) {
      return const Center(
        child: Text(
          'No items available',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Expanded(

      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          childAspectRatio: 0.56,
        ),

        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          bool isLiked = WishlistHandle.isItemInWishlist(item);

          return GridItem(
            item: item,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarpetPatternPage(
                    carpetId: item.id,
                    carpetName: item.text,
                  ),
                ),
              );
            },
            onLikeToggle: () async {
              if (isLiked) {
                await WishlistHandle.removeItem(item);
              } else {
                await WishlistHandle.addItem(item);
              }
              setState(() {});
            },
            isLiked: isLiked,
          );
        },
      ),

    );
  }

  void _unfocusKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _unfocusKeyboard(context),
      child: Scaffold(




        backgroundColor: AppStyles.backgroundSecondry,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 3.0, 15.0, 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGridView(),
            ],
          ),
        ),
      ),
    );
  }
}
