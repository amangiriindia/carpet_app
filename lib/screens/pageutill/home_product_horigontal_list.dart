import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../const.dart';
import '../collection_screen.dart';
import 'carpet_pattern_choose.dart';
import 'carpet_product_item.dart';

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
          price: collection['price'].toString(),
          id: collection['_id'],
        );
      }).toList();

      return items.take(9).toList(); // Limit to 9 items
    } else {
      throw Exception('Failed to load collections');
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
            return LayoutBuilder(
              builder: (context, constraints) {
                // Calculate the number of rows based on the number of items
                int itemCount = snapshot.data!.length;
                double itemHeight = 320.0; // Height of each item
                int crossAxisCount = 2; // Number of items per row
                int numberOfRows = (itemCount / crossAxisCount).ceil();
                double totalHeight = itemHeight * numberOfRows;

                return SizedBox(
                  height: totalHeight,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(), // Disable scroll for GridView
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items per row
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      return CarpetItemCard(
                        imageData: snapshot.data![index].imageData,
                        text: snapshot.data![index].text,
                        price: snapshot.data![index].price,
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

class CollectionItem {
  final Uint8List imageData;
  final String text;
  final String price;
  final String id;

  CollectionItem({
    required this.imageData,
    required this.text,
    required this.price,
    required this.id,
  });
}
