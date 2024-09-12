import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/const.dart';
import '../pageutill/carpet_pattern_choose.dart';

class CollectionGrid extends StatefulWidget {
  const CollectionGrid({Key? key}) : super(key: key);

  @override
  _CollectionGridState createState() => _CollectionGridState();
}

class _CollectionGridState extends State<CollectionGrid> with TickerProviderStateMixin {
  late Future<List<CollectionItem>> _allCollections;

  @override
  void initState() {
    super.initState();
    _allCollections = fetchCollections();
  }

  Future<List<CollectionItem>> fetchCollections() async {
    final prefs = await SharedPreferences.getInstance();
    final String cacheKey = 'cached_collections';
    final String timestampKey = 'cache_timestamp';

    final cachedData = prefs.getString(cacheKey);
    final cachedTimestamp = prefs.getInt(timestampKey);

    final now = DateTime
        .now()
        .millisecondsSinceEpoch;
    final cacheDuration = Duration(hours: 1); // Define cache duration

    // Check if cache is still valid
    if (cachedData != null &&
        cachedTimestamp != null &&
        now - cachedTimestamp < cacheDuration.inMilliseconds) {
      // Cache is valid
      final List<dynamic> allCollections = json.decode(cachedData);
      return allCollections.map((collection) {
        List<int> imageData = List<int>.from(
            collection['photo']['data']['data']);
        return CollectionItem(
          imageData: Uint8List.fromList(imageData),
          text: collection['name'],
          id: collection['_id'],
        );
      }).toList();
    } else {
      // Cache is expired or not available, fetch from API
      final response = await http.get(
        Uri.parse('${APIConstants.API_URL}/api/v1/carpet/all-carpet'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<dynamic> allCollections = jsonResponse['carpets'];
        List<CollectionItem> items = allCollections.map((collection) {
          List<int> imageData = List<int>.from(
              collection['photo']['data']['data']);
          return CollectionItem(
            imageData: Uint8List.fromList(imageData),
            text: collection['name'],
            id: collection['_id'],
          );
        }).toList();

        // Cache the new data and update the timestamp
        prefs.setString(cacheKey, json.encode(allCollections));
        prefs.setInt(timestampKey, now);

        return items;
      } else {
        throw Exception('Failed to load collections');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FutureBuilder<List<CollectionItem>>(
        future: _allCollections,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CommonFunction.showLoadingIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No collections found.'),
            );
          } else {
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Adjust to 2 columns for larger cards
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.7, // Adjust this to change card height/width ratio
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CollectionGridItem(
                  imageData: snapshot.data![index].imageData,
                  text: snapshot.data![index].text,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CarpetPatternPage(
                              carpetId: snapshot.data![index].id,
                              carpetName: snapshot.data![index].text,
                            ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CollectionGridItem extends StatelessWidget {
  final Uint8List imageData;
  final String text;
  final VoidCallback onTap;

  const CollectionGridItem({
    required this.imageData,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250.0, // Set a fixed height for the card
        decoration: BoxDecoration(
          color: Colors.white, // Set the background color to white
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: AppStyles.primaryColorStart), // Add a black border to the card
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)), // Round the top corners of the image
                child: Image.memory(
                  imageData,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  gaplessPlayback: true,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200, // Set a fallback background color
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Image failed to load", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  },
                  frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      return child;
                    } else {
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        child: child,
                      );
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0), // Padding around the text
              child: Text(
                text,
                style: AppStyles.secondaryBodyTextStyle.copyWith(
                  color: Colors.black, // Use black color for the text
                  fontWeight: FontWeight.bold, // Make the text bold
                ),
                textAlign: TextAlign.center, // Center align the text
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class CollectionItem {
  final Uint8List imageData;
  final String text;
  final String id;

  CollectionItem({
    required this.imageData,
    required this.text,
    required this.id,
  });
}