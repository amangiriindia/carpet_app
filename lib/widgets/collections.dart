import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';
import '../screens/pageutill/carpet_pattern_choose.dart';

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

    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheDuration = Duration(hours: 1); // Define cache duration

    // Check if cache is still valid
    if (cachedData != null &&
        cachedTimestamp != null &&
        now - cachedTimestamp < cacheDuration.inMilliseconds) {
      // Cache is valid
      final List<dynamic> allCollections = json.decode(cachedData);
      return allCollections.map((collection) {
        List<int> imageData = List<int>.from(collection['photo']['data']['data']);
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
          List<int> imageData = List<int>.from(collection['photo']['data']['data']);
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
            return const Center(
              child: SpinKitRotatingCircle(
                color: Colors.white,
                size: 50.0,
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
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0, // Adjusted childAspectRatio
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
                        builder: (context) => CarpetPatternPage(
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.memory(
                imageData,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded || frame != null) {
                    return child;
                  } else {
                    return Center(
                      child: Container(
                        width: 75,
                        height: 75,
                         child: SpinKitThreeBounce(
                        color: AppStyles.primaryColorStart,
                        size: 20.0,
                      ),

                  ),
                    );
                  }
                },
              ),
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    // padding: const EdgeInsets.all(5.0), // Reduced padding
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.0,
                        overflow: TextOverflow.ellipsis, // Control text overflow
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
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