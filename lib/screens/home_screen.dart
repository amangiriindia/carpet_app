import 'package:OACrugs/screens/pageutill/search_home_page.dart';
import 'package:flutter/material.dart';
import 'package:OACrugs/constant/const.dart';
import 'package:OACrugs/screens/home/home_product_horigontal_list.dart';
import 'package:OACrugs/components/home_title_heading.dart';
import 'home/banner.dart';
import 'home/collections.dart';
import 'home/placement_guide_list.dart';
import 'home/recent_projects.dart';
import 'base/base_screen.dart';
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

  @override
  void initState() {
    super.initState();

  }



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
          Container(
            color: AppStyles.backgroundSecondry,

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
                  const CollectionGrid(),
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
          const SearchHomePage(),
          // Wishlist Screen Page
          const WishListScreen(),
          // Collection Screen Page
        ],
      ),
    );
  }
}
