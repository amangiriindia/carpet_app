import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PendingOueryScreen extends StatefulWidget {
  const PendingOueryScreen({Key? key}) : super(key: key);

  @override
  State<PendingOueryScreen> createState() => _PendingOueryScreenState();
}

class _PendingOueryScreenState extends State<PendingOueryScreen> {
  late String _userId;
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '66c4aa81c3e37d9ff6c4be6c';
    });
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final url = 'https://oac.onrender.com/api/v1/enquiry/user/enquiry-pending';
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
            // Ensure 'data' is a List<int>
            List<int> photoData = List<int>.from(item['photo']['data']['data']);

            return Order(
              imagePath: 'data:image/jpeg;base64,' + base64Encode(Uint8List.fromList(photoData)),
              name: item['product']['name']?? 'Unknown',
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
                      'Pending Query',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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

  const OrderWidget({Key? key, required this.order}) : super(key: key);

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
                    '₹${order.price.toStringAsFixed(2)}',  // Using INR symbol ₹
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
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Pending Query',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black
                      ),
                    ),
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
