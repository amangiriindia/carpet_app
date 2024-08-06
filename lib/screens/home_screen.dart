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
          // Home Screen Page
          ListView(
            children: [
              const BannerSection(bannerImages: [
                'assets/login/welcome.png',
                'assets/login/welcome.png',
                'assets/login/welcome.png',
                'assets/login/welcome.png',
                'assets/login/welcome.png',
                'assets/login/welcome.png',
              ]),
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
              const RecentProjectsSection(projects: [
                RecentProjectItemWithImage(
                  imagePath: 'assets/login/welcome.png',
                  projectName: 'Luxury Living Room \n      in Manhattan',
                  projectDescription: 'A sleek, modern aesthetic featuring eclectic patterns, cozy seating, and a character to rival any gathering space.',
                ),
                RecentProjectItemWithImage(
                  imagePath: 'assets/login/welcome.png',
                  projectName: 'Stylish Office Space \n      in San Francisco',
                  projectDescription: 'An office with a modern vibe, featuring open spaces, ergonomic seating, and a creative atmosphere.',
                ),
                RecentProjectItemWithImage(
                  imagePath: 'assets/login/welcome.png',
                  projectName: 'Cozy Apartment \n      in Brooklyn',
                  projectDescription: 'A small but charming apartment with a cozy feel, featuring warm tones and stylish furniture.',
                ),
                RecentProjectItemWithImage(
                  imagePath: 'assets/login/welcome.png',
                  projectName: 'Cozy Apartment \n      in Brooklyn',
                  projectDescription: 'A small but charming apartment with a cozy feel, featuring warm tones and stylish furniture.',
                ),
              ]),
              const SizedBox(height: 10),
              const Center(child: SectionTitle(title: "Shops To Explore")),
              ShopsToExploreList(width: 150.0),
              const SizedBox(height: 10),
              const Center(child: SectionTitle(title: "Guide for Placement")),
              const PlacementGuideList(),
            ],
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

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 35.0), // Add margin to the bottom
            child: Image.asset(
              'assets/image/home_heading_icon.png',
              width: 10,
              height: 15,
            ),
          ),
          const SizedBox(width: 0.0),
          // Add some spacing between the image and text
          Stack(
            children: [
              // Left border
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2.0, // Adjust the width of the left border
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF991F35), Color(0xFF330A12)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // Bottom border
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 2.0, // Adjust the height of the bottom border
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF991F35), Color(0xFF330A12)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
