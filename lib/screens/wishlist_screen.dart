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
  late Future<List<CollectionItem>> _wishlistFuture;

  @override
  void initState() {
    super.initState();
    _wishlistFuture = _getWishlistItems();
  }

  Future<List<CollectionItem>> _getWishlistItems() async {
    // Simulate a delay before fetching the items
    await Future.delayed(const Duration(seconds: 1));
    return WishlistHandle.wishlistItems;
  }

  Future<void> _refreshWishlist() async {
    setState(() {
      _wishlistFuture = _getWishlistItems();
    });
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
            child: FutureBuilder<List<CollectionItem>>(
              future: _wishlistFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      color: AppStyles.primaryColorStart,
                      size: 50.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                  final wishlistItems = snapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
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
                          WishlistHandle.removeItem(item);
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
