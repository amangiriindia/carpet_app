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

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          orders = (data['enquiries'] as List).map((item) {
            List<int> photoData = List<int>.from(item['photo']['data']['data']);

            return Order(
              imagePath: 'data:image/jpeg;base64,' + base64Encode(Uint8List.fromList(photoData)),
              name: item['product']['name'] ?? 'Unknown',
              price: item['product']['price']?.toDouble() ?? 0.0,
              size: item['productSize']['size'] ?? 'Unknown',
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
  final String imagePath;
  final String name;
  final double price;
  final String size;

  Order({
    required this.imagePath,
    required this.name,
    required this.price,
    required this.size,
  });
}

class OrderWidget extends StatelessWidget {
  final Order order;

  const OrderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Set the background color of the Card to white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Image.memory(
              base64Decode(order.imagePath.split(',')[1]),
              width: 110,
              height: 140,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.name,
                    style: TextStyle(
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
                      SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          // Add your button functionality here, e.g., navigate to the orders page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OrderScreen()), // Replace OrdersPage with your target page
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Go To Orders',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
