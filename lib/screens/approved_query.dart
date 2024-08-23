import 'package:OACrugs/screens/pageutill/place_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'order_screen.dart';

class ApprovedQueryScreen extends StatefulWidget {
  const ApprovedQueryScreen({super.key});

  @override
  State<ApprovedQueryScreen> createState() => _ApprovedQueryScreenState();
}

class _ApprovedQueryScreenState extends State<ApprovedQueryScreen> {
  late String _userId;
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId') ?? '66c4aa81c3e37d9ff6c4be6c';
    // Once userId is loaded, fetch orders
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    if (_userId.isEmpty) {
      print('User ID is not initialized');
      return;
    }

    final url = 'https://oac.onrender.com/api/v1/enquiry/user/enquiry-approve';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"user": _userId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          orders = (data['enquiries'] as List).map((item) {
            List<int> photoData = List<int>.from(item['photo']['data']['data']);

            return Order(
              enquiryId: item['_id'] ?? 'Unknown',
              imagePath: 'data:image/jpeg;base64,' + base64Encode(Uint8List.fromList(photoData)),
              carpetName: item['product']['name'] ?? 'Unknown',
              patternName: item['patternId']['name'] ?? 'Unknown',
              size: item['productSize']['size'] ?? 'Unknown',
              price: item['product']['price']?.toDouble() ?? 0.0,
              shape: item['shape']['shape'] ?? 'Unknown',
              description: item['product']['description'] ?? 'No description available',
            );
          }).toList();
        });
      }
    } else {
      // Handle errors if needed
      print('Failed to load orders');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.14),
                      child: IconButton(
                        icon: const Icon(Icons.login_outlined, color: Colors.black54),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 80),
                    const Icon(Icons.list_alt_outlined, color: Colors.black54),
                    const SizedBox(width: 4),
                    const Text(
                      'Approved Query',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true, // Use this property to limit the height
                  physics: NeverScrollableScrollPhysics(), // Disable scrolling
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return OrderWidget(order: orders[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Order {
  final String enquiryId;
  final String imagePath;
  final String carpetName;
  final String patternName;
  final String size;
  final double price;
  final String shape;
  final String description;

  Order({
    required this.enquiryId,
    required this.imagePath,
    required this.carpetName,
    required this.patternName,
    required this.size,
    required this.price,
    required this.shape,
    required this.description,
  });
}
class OrderWidget extends StatelessWidget {
  final Order order;

  const OrderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            // Display image with error handling
            Image.memory(
              base64Decode(order.imagePath.split(',')[1]),
              width: 110,
              height: 140,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Error loading image'));
              },
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.carpetName,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '₹${order.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.size,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const Text('Approved', style: TextStyle(color: Colors.green)),
                      const SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmOrderPage(
                                enquiryId: order.enquiryId,
                                imagePath: order.imagePath,
                                carpetName: order.carpetName,
                                patternName: order.patternName,
                                size: order.size,
                                price: order.price,
                                shape: order.shape,
                                description: order.description,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Place Order',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}






