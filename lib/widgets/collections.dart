import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../screens/collection_screen.dart';
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
      return items;
    } else {
      throw Exception('Failed to load collections');
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
            // Replace CircularProgressIndicator with SpinKit
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
              physics: const NeverScrollableScrollPhysics(), // Disable scrolling
              shrinkWrap: true, // Adjust the height of the grid to fit its content
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 cards per row
                crossAxisSpacing: 8.0, // Space between columns
                mainAxisSpacing: 8.0, // Space between rows
                childAspectRatio: 0.9, // Adjust the height to width ratio of the cards
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
          border: Border.all(color: Colors.grey.shade300), // Optional border for each card
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0), // Adjust border radius as needed
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.memory(
                imageData, // Display the image from the API
                fit: BoxFit.cover,
                gaplessPlayback: true,
                frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded || frame != null) {
                    return child;
                  } else {
                    return Center( // Wrapped in a Container for demonstration
                      child: Container(
                        width: 200, // Provide enough space
                        height: 200,
                        child: SpinKitFadingCircle(
                          size: 50.0,
                          itemBuilder: (BuildContext context, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                color:
                              index.isOdd ? Colors.red : Colors.green, // Adjusted condition
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
              Container(
                color: Colors.black.withOpacity(0.3), // Semi-transparent overlay
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(5.0), // Adjust padding as needed
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6), // Background color of the text box
                      border: Border.all(color: Colors.white, width: 1), // White border
                      borderRadius: BorderRadius.circular(5.0), // Rounded corners for the text box
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.0, // Adjust text size as needed
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
