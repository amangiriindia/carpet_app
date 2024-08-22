import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import '../const.dart';
import '../widgets/grid_item.dart';

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
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<CollectionItem> _items = [];
  List<CollectionItem> _filteredItems = [];
  String _searchQuery = '';
  List<String> _likedItemIds = [];

  @override
  void initState() {
    super.initState();
    _fetchCollections();
    _loadLikedItems();
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
            price: collection['price'].toString(),
            id: collection['_id'],
          );
        }).toList();

        setState(() {
          _items = items.take(9).toList(); // Limit to 9 items
          _filteredItems = _items;
        });
      } else {
        throw Exception('Failed to load collections');
      }
    } catch (error) {
      print('Error fetching collections: $error');
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

  Future<void> _toggleLike(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_likedItemIds.contains(id)) {
        _likedItemIds.remove(id);
      } else {
        _likedItemIds.add(id);
      }
      await prefs.setStringList('liked_items', _likedItemIds);
      setState(() {});
    } catch (error) {
      print('Error toggling like: $error');
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: GestureDetector(
        onTap: () => _unfocusKeyboard(context),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 16.0),
                _buildFilterRow(),
                const SizedBox(height: 16.0),
                _buildGridView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: _search,
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Persian Tabriz',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '${_filteredItems.length} results',
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.black),
          ),
          child: InkWell(
            onTap: () => _showFilterOptions(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.filter_list, color: Colors.black, size: 16.0),
                const SizedBox(width: 4.0),
                const Text(
                  'Filter',
                  style: TextStyle(color: Colors.black, fontSize: 12.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridView() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          return GridItem(
            item: item,
            onTap: () {
              // Handle item tap
            },
            onLikeToggle: () => _toggleLike(item.id),
            isLiked: _likedItemIds.contains(item.id),
          );
        },
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              for (var i = 1; i <= 4; i++)
                ListTile(
                  leading: const Icon(Icons.filter_alt),
                  title: Text('Option $i'),
                  onTap: () {
                    // Handle filter option $i
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _unfocusKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
