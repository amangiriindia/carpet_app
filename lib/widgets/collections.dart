import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../screens/collection_screen.dart';

class HorizontalImageList extends StatefulWidget {
  const HorizontalImageList({Key? key}) : super(key: key);

  @override
  _HorizontalImageListState createState() => _HorizontalImageListState();
}

class _HorizontalImageListState extends State<HorizontalImageList> {
  late Future<List<CollectionItem>> _allCollections;

  @override
  void initState() {
    super.initState();
    _allCollections = fetchCollections();
  }

  Future<List<CollectionItem>> fetchCollections() async {
    final response = await http.get(
      Uri.parse('${APIConstants.API_URL}/api/v1/collection/all-collection'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> allCollections = jsonResponse['allCollection'];
      List<CollectionItem> items = allCollections.map((collection) {
        List<int> imageData = List<int>.from(collection['photo']['data']['data']);
        return CollectionItem(
          imageData: Uint8List.fromList(imageData),
          text: collection['name'],
          id: collection['_id'], // Extract collection ID
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
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Container(
        height: 150.0,
        child: FutureBuilder<List<CollectionItem>>(
          future: _allCollections,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
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
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return HorizontalImageItem(
                    imageData: snapshot.data![index].imageData,
                    text: snapshot.data![index].text,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CollectionScreen(
                            collectionId: snapshot.data![index].id,
                            collectionName: snapshot.data![index].text,
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
      ),
    );
  }
}

class HorizontalImageItem extends StatelessWidget {
  final Uint8List imageData;
  final String text;
  final VoidCallback onTap;

  HorizontalImageItem({
    required this.imageData,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 110.0, // Set width to 110px
        height: 110.0, // Set height to 110px
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0), // Adjust border radius as needed
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image with small progress indicator
              Image.memory(
                imageData, // Display the image from the API
                fit: BoxFit.cover,
                gaplessPlayback: true,
                frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded || frame != null) {
                    // Image is loaded
                    return child;
                  } else {
                    // Show small progress indicator while loading
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5, // Adjust the stroke width to make it smaller
                      ),
                    );
                  }
                },
              ),
              Container(
                color: Colors.black.withOpacity(0.3), // Semi-transparent background color
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(5.0), // Adjust padding as needed
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6), // Background color of the box
                      border: Border.all(color: Colors.white, width: 1), // White border
                      borderRadius: BorderRadius.circular(5.0), // Rounded corners
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.0, // Adjust text size as needed
                      ),
                      textAlign: TextAlign.center, // Center align text
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
