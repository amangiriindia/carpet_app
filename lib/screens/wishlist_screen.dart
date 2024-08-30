import 'package:flutter/material.dart';
import 'package:OACrugs/screens/pageutill/carpet_pattern_choose.dart';
import 'package:OACrugs/screens/pageutill/home_title_heading.dart';
import 'package:OACrugs/screens/pageutill/wishlisthandle.dart';
import '../../const.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  late Future<void> _wishlistFuture;

  @override
  void initState() {
    super.initState();
    _wishlistFuture = _loadWishlistItems();
  }

  Future<void> _loadWishlistItems() async {
    await WishlistHandle.loadWishlistFromPrefs();
    setState(() {});
  }

  Future<void> _refreshWishlist() async {
    await _loadWishlistItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundSecondry,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SectionTitle(title: "Wishlist"),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<void>(
              future: _wishlistFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      color: AppStyles.primaryColorStart,
                      size: 50.0,
                    ),
                  );
                } else if (WishlistHandle.wishlistItems.isEmpty) {
                  return const Center(
                    child: Text(
                      'No items in wishlist',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  final wishlistItems = WishlistHandle.wishlistItems;
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      childAspectRatio: 0.56,
                    ),
                    itemCount: wishlistItems.length,


                    itemBuilder: (context, index) {
                      final item = wishlistItems[index];
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
                          await WishlistHandle.removeItem(item);
                          await _refreshWishlist();
                        },
                        isLiked: WishlistHandle.isItemInWishlist(item),
                      );
                    },
                  );


                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
