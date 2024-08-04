import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_navigation_bar.dart';
import '../widgets/profile_drawer.dart';
import '../wish_list_provider.dart';
import 'enquiry_screen.dart';
import 'home_screen.dart';
import 'notification_screen.dart';
import 'search_screen.dart';
import 'wishlist_screen.dart';
import '../widgets/grid_item.dart';

class CollectionScreen extends StatefulWidget {
  final int initialIndex;

  const CollectionScreen({super.key, this.initialIndex = 2});

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (index) {
            case 0:
              return const HomeScreen();
            case 1:
              return const SearchScreen();
            case 2:
              return const WishListScreen();
            default:
              return const HomeScreen();
          }
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
                    Navigator.pop(context);
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
    return GestureDetector(
      onTap: () => _unfocusKeyboard(context),
      child: Scaffold(
        appBar: const CustomAppBar(),
        drawer: const NotificationScreen(),
        endDrawer: const ProfileDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14),
                    child: IconButton(
                      icon: const Icon(Icons.login_outlined,
                          color: Colors.black54),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 65),
                  const Text(
                    'Collections',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Bohemian Bliss',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              _buildFilterRow(context),
              const SizedBox(height: 16.0),
              _buildGridView(context),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '10,000 results',
          style: TextStyle(fontSize: 12.0),
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

  Widget _buildGridView(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          WishListItem item = WishListItem(
            id: 'item_$index',
            imagePath: 'assets/login/welcome.png',
            name: 'Persian Tabriz',
            price: 12999.0,
            size: '151 x 102 cm',
          );

          return Consumer<WishListProvider>(
            builder: (context, wishListProvider, child) {
              bool isFavorite = wishListProvider.isInWishList(item);
              return GridItem(
                item: item,
                isFavorite: isFavorite,
                onFavoriteToggle: () {
                  setState(() {
                    if (isFavorite) {
                      wishListProvider.removeItem(item);
                    } else {
                      wishListProvider.addItem(item);
                    }
                  });
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EnquiryScreen(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
