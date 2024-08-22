import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/grid_item.dart';
import '../wish_list_provider.dart';
import 'enquiry_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set the entire page background to white
      child: GestureDetector(
        onTap: () => _unfocusKeyboard(context),
        child: Scaffold(
          backgroundColor: Colors.white, // Ensure the Scaffold itself is white
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 16.0),
                _buildFilterRow(context),
                const SizedBox(height: 16.0),
                _buildGridView(context),
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
          const Expanded(
            child: TextField(
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

  Widget _buildFilterRow(BuildContext context) {
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
            const Text(
              '10,000 results',
              style: TextStyle(fontSize: 12.0),
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
                Icon(Icons.filter_list, color: Colors.black, size: 16.0),
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

  Widget _buildGridView(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: 6, // Adjust this based on your data
        itemBuilder: (context, index) {
          return Consumer<WishListProvider>(
            builder: (context, wishListProvider, child) {
              final item = WishListItem(
                id: 'item_$index', // Unique identifier for each item
                imagePath: Uint8List(0), // Replace with actual image data
                name: 'Persian Tabriz',
                price: 12999.0,
                size: '151 x 102 cm',
              );
              final isInWishList = wishListProvider.isInWishList(item);
              return GridItem(
                item: item,
                isFavorite: isInWishList,
                onFavoriteToggle: () {
                  if (isInWishList) {
                    wishListProvider.removeItem(item);
                  } else {
                    wishListProvider.addItem(item);
                  }
                },
                onTap: () {

                },
              );
            },
          );
        },
      ),
    );
  }
}
