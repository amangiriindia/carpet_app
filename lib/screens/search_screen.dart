import 'package:OACrugs/screens/pageutill/carpet_pattern_choose.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';
import '../widgets/grid_item.dart';

// Your existing CollectionItem class
class CollectionItem {
  final Uint8List imageData;
  final String text;
  final String price;
  final double priceValue;
  final String id;

  CollectionItem({
    required this.imageData,
    required this.text,
    required this.price,
    required this.priceValue,
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
  Set<String> _selectedPriceFilters = {};

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
          double priceValue = double.tryParse(collection['price'].toString()) ?? 0.0;
          return CollectionItem(
            imageData: Uint8List.fromList(imageData),
            text: collection['name'],
            price: '₹${collection['price']}',
            priceValue: priceValue,
            id: collection['_id'],
          );
        }).toList();
        setState(() {
          _items = items;
          _filteredItems = List.from(_items); // Initialize filtered items
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
      setState(() {
        if (_likedItemIds.contains(id)) {
          _likedItemIds.remove(id);
        } else {
          _likedItemIds.add(id);
        }
        prefs.setStringList('liked_items', _likedItemIds);
      });
    } catch (error) {
      print('Error toggling like: $error');
    }
  }

  void _search(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredItems = _items.where((item) {
        bool matchesSearchQuery = item.text.toLowerCase().contains(_searchQuery);
        bool matchesPriceFilter = _selectedPriceFilters.isEmpty ||
            _selectedPriceFilters.any((filter) {
              if (filter == 'Below ₹500') {
                return item.priceValue < 500;
              } else if (filter == '₹1000 to ₹2000') {
                return item.priceValue >= 1000 && item.priceValue <= 2000;
              } else if (filter == '₹2000 to ₹3000') {
                return item.priceValue >= 2000 && item.priceValue <= 3000;
              } else if (filter == 'Above ₹5000') {
                return item.priceValue > 5000;
              } else {
                return false;
              }
            });
        return matchesSearchQuery && matchesPriceFilter;
      }).toList();
    });
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
              _buildPriceFilterOption('Below ₹500', 0, 500),
              _buildPriceFilterOption('₹1000 to ₹2000', 1000, 2000),
              _buildPriceFilterOption('₹2000 to ₹3000', 2000, 3000),
              _buildPriceFilterOption('Above ₹5000', 5000, double.infinity),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceFilterOption(String label, double minPrice, double maxPrice) {
    return CheckboxListTile(
      title: Text(label),
      value: _selectedPriceFilters.contains(label),
      onChanged: (bool? selected) {
        setState(() {
          if (selected == true) {
            _selectedPriceFilters.add(label);
          } else {
            _selectedPriceFilters.remove(label);
          }
          _applyFilters();
          Navigator.pop(context);
        });
      },
    );
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: _search,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
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
              style: AppStyles.primaryBodyTextStyle,
            ),
            Text(
              '${_filteredItems.length} results',
              style: AppStyles.secondaryBodyTextStyle,
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
              children: const [
                Icon(Icons.filter_list, color: Colors.black, size: 16.0),
                SizedBox(width: 4.0),
                Text(
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
            onLikeToggle: () => _toggleLike(item.id),
            isLiked: _likedItemIds.contains(item.id),
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
    return Container(
      color: AppStyles.backgroundSecondry,
      child: GestureDetector(
        onTap: () => _unfocusKeyboard(context),
        child: Scaffold(
          backgroundColor: AppStyles.backgroundSecondry,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 3.0, 15.0, 15.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                // const SizedBox(height: 16.0),
                // _buildFilterRow(),
                const SizedBox(height: 16.0),
                _buildGridView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
