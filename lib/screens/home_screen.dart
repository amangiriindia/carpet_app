import 'package:OACrugs/screens/pageutill/home_product_horigontal_list.dart';
import 'package:OACrugs/screens/pageutill/home_title_heading.dart';
import 'package:flutter/material.dart';
import '../widgets/banner.dart';
import '../widgets/collections.dart';
import '../widgets/placement_guide_list.dart';
import '../widgets/recent_projects.dart';
import '../widgets/shop_list.dart';
import 'base_screen.dart';
import 'search_screen.dart';
import 'wishlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      selectedIndex: _selectedIndex,
      onTap: _onItemTapped,
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          // Home Screen Page with single scroll
          Container(
            color: Colors.white, // Set background color to white
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BannerSection(),

                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/collection_screen',
                        arguments: {'selectedIndex': 3},
                      );
                    },
                    child: const Center(child: SectionTitle(title: "Collections")),
                  ),
                  const HorizontalImageList(),
                  const SizedBox(height: 10),
                  const Center(child: SectionTitle(title: "Recent Projects")),
                  RecentProjectsSection(),
                  const SizedBox(height: 10),
                  const Center(child: SectionTitle(title: "Shops To Explore")),
                  const HomeCarpetItems(), // Include your carpet items here
                  const SizedBox(height: 10),
                  const Center(child: SectionTitle(title: "Guide for Placement")),
                  const PlacementGuideList(),
                ],
              ),
            ),
          ),
          // Search Screen Page
          const SearchScreen(),
          // Wishlist Screen Page
          const WishListScreen(),
          // Collection Screen Page
        ],
      ),
    );
  }
}
