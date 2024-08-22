// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import '../const.dart';
// import '../widgets/custom_app_bar.dart';
// import '../widgets/custom_navigation_bar.dart';
// import '../widgets/profile_drawer.dart';
// import '../wish_list_provider.dart';
// import 'enquiry_screen.dart';
// import 'home_screen.dart';
// import 'notification_screen.dart';
// import 'search_screen.dart';
// import 'wishlist_screen.dart';
// import '../widgets/grid_item.dart';
// import 'package:http/http.dart' as http;
//
// class CollectionScreen extends StatefulWidget {
//   final String collectionId;
//   final String collectionName;
//   final int initialIndex;
//
//   const CollectionScreen({
//     required this.collectionId,
//     required this.collectionName,
//     this.initialIndex = 2,
//     super.key,
//   });
//
//   @override
//   _CollectionScreenState createState() => _CollectionScreenState();
// }
//
// class _CollectionScreenState extends State<CollectionScreen> {
//   late int _selectedIndex;
//   late Future<List<SingleCollectionItem>> _singlecollectionitems;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialIndex;
//     _singlecollectionitems = fetchSingleCollections(); // Call the function
//   }
//
//   Future<List<SingleCollectionItem>> fetchSingleCollections() async {
//     final response = await http.get(
//       Uri.parse('${APIConstants.API_URL}/api/v1/carpet/all-carpet'),
//     );
//        print(response.statusCode);
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       // Add a null check for 'getAllCarpets'
//       final List<dynamic> getAllCarpets = jsonResponse['getAllCarpets'] ?? [];
//
//       // Ensure getAllCarpets is a list
//       if (getAllCarpets is List<dynamic>) {
//         List<SingleCollectionItem> items = getAllCarpets.map<SingleCollectionItem>((collection) {
//           List<int> imageData = List<int>.from(collection['photo']['data']['data'] ?? []);
//           return SingleCollectionItem(
//             imageData: imageData.isNotEmpty ? Uint8List.fromList(imageData) : Uint8List(0),
//             collectionId: collection['collection'] ?? 'Unknown Collection',
//             carpetname: collection['name'] ?? 'Unknown ID',
//             price: (collection['price'] ?? 0).toString(),
//             dimension: collection['dimension'] ?? 'Unknown Dimension',
//           );
//         }).toList();
//         return items;
//       } else {
//         throw Exception('Unexpected response format');
//       }
//     } else {
//       throw Exception('Failed to load collections');
//     }
//   }
//
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) {
//           switch (index) {
//             case 0:
//               return const HomeScreen();
//             case 1:
//               return const SearchScreen();
//             case 2:
//               return const WishListScreen();
//             default:
//               return const HomeScreen();
//           }
//         },
//       ),
//     );
//   }
//
//   void _showFilterOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Filter Options',
//                 style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10.0),
//               for (var i = 1; i <= 4; i++)
//                 ListTile(
//                   leading: const Icon(Icons.filter_alt),
//                   title: Text('Option $i'),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _unfocusKeyboard(BuildContext context) {
//     FocusScope.of(context).unfocus();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _unfocusKeyboard(context),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: const CustomAppBar(),
//         drawer: const NotificationScreen(),
//         endDrawer: const ProfileDrawer(),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Transform(
//                     alignment: Alignment.center,
//                     transform: Matrix4.rotationY(3.14),
//                     child: IconButton(
//                       icon: const Icon(Icons.login_outlined, color: Colors.black54),
//                       onPressed: () => Navigator.of(context).pop(),
//                     ),
//                   ),
//                   const SizedBox(width: 65),
//                   const Text(
//                     'Collections',
//                     style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//               Text(
//                 widget.collectionName,
//                 style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16.0),
//               _buildFilterRow(context),
//               const SizedBox(height: 16.0),
//               _buildGridView(context),
//             ],
//           ),
//         ),
//         bottomNavigationBar: CustomBottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFilterRow(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           '10,000 results',
//           style: TextStyle(fontSize: 12.0),
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20.0),
//             border: Border.all(color: Colors.black),
//           ),
//           child: InkWell(
//             onTap: () => _showFilterOptions(context),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.filter_list, color: Colors.black, size: 16.0),
//                 const SizedBox(width: 4.0),
//                 const Text(
//                   'Filter',
//                   style: TextStyle(color: Colors.black, fontSize: 12.0),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildGridView(BuildContext context) {
//     return Expanded(
//       child: FutureBuilder<List<SingleCollectionItem>>(
//         future: _singlecollectionitems,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No items found.'));
//           } else {
//             return GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.75,
//                 crossAxisSpacing: 16.0,
//                 mainAxisSpacing: 16.0,
//               ),
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 SingleCollectionItem item = snapshot.data![index];
//
//                 return GridItem(
//                   item: WishListItem(
//                     id: item.collectionId,
//                     imagePath: item.imageData, // Pass the image data directly
//                     name: item.carpetname,
//                     price: double.parse(item.price),
//                     size: item.dimension,
//                   ),
//                   isFavorite: false, // Implement your favorite logic if needed
//                   onFavoriteToggle: () {
//                     // Implement your favorite toggle logic if needed
//                   },
//                   onTap: () {
//
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
// class SingleCollectionItem {
//   final Uint8List imageData;
//   final String price;
//   final String collectionId;
//   final String carpetname;
//   final String dimension;
//
//   SingleCollectionItem({
//     required this.imageData,
//     required this.price,
//     required this.collectionId,
//     required this.carpetname,
//     required this.dimension,
//   });
// }
