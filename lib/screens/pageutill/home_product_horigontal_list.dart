import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For toast messages
import 'package:http/http.dart' as http;
import '../../const.dart';
import 'carpet_pattern_choose.dart';
import 'wishlisthandle.dart'; // Corrected import path for WishlistHandle

class HomeCarpetItems extends StatefulWidget {
  const HomeCarpetItems({Key? key}) : super(key: key);

  @override
  _HomeCarpetItemsState createState() => _HomeCarpetItemsState();
}

class _HomeCarpetItemsState extends State<HomeCarpetItems> {
  late Future<List<CollectionItem>> _allCollections;

  @override
  void initState() {
    super.initState();
    _allCollections = fetchCollections();
  }

  Future<List<CollectionItem>> fetchCollections() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cached_carpet_items';
    final cacheTimestampKey = 'cache_timestamp';
    final cacheDuration = const Duration(minutes: 10); // Adjust cache duration as needed

    final currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    final lastCacheTimestamp = prefs.getInt(cacheTimestampKey) ?? 0;
    final shouldFetchFromServer = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(lastCacheTimestamp)) > cacheDuration;

    if (shouldFetchFromServer) {
      final response = await http.get(
        Uri.parse('${APIConstants.API_URL}/api/v1/carpet/all-carpet'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<dynamic> allCollections = jsonResponse['carpets'];
        List<CollectionItem> items = allCollections.map((collection) {
          List<int> imageData = List<int>.from(collection['photo']['data']['data']); // Convert dynamic list to List<int>
          return CollectionItem(
            imageData: Uint8List.fromList(imageData), // Convert List<int> to Uint8List
            text: collection['name'],
            price: '₹${collection['price']}',
            id: collection['_id'],
          );
        }).toList();

        prefs.setString(cacheKey, json.encode(items.map((e) => e.toJson()).toList())); // Fixed JSON serialization
        prefs.setInt(cacheTimestampKey, currentTimestamp);
        return items.take(9).toList(); // Limit to 9 items
      } else {
        throw Exception('Failed to load collections');
      }
    } else {
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        final List<dynamic> decodedData = json.decode(cachedData);
        final List<CollectionItem> items = decodedData.map((e) => CollectionItem.fromJson(e)).toList(); // Fixed deserialization
        return items.take(9).toList(); // Limit to 9 items
      } else {
        throw Exception('No cached data available');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FutureBuilder<List<CollectionItem>>(
        future: _allCollections,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitThreeBounce(
                color: AppStyles.primaryColorStart,
                size: 20.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No collections found.'),
            );
          } else {
            return LayoutBuilder(
              builder: (context, constraints) {
                int itemCount = snapshot.data!.length;
                double itemHeight = 320;
                int crossAxisCount = 2;
                int numberOfRows = (itemCount / crossAxisCount).ceil();
                double totalHeight = itemHeight * numberOfRows;

                return SizedBox(
                  height: totalHeight,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      childAspectRatio: 0.6,
                    ),



                    itemCount: itemCount,

                    itemBuilder: (context, index) {
                      CollectionItem item = snapshot.data![index];
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
                          setState(() {}); // Call setState synchronously
                        },

                        isLiked: isLiked,
                      );
                    },


                  ),
                );
              },
            );

          }
        },
      ),
    );
  }
}
