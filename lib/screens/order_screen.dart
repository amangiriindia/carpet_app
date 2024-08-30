import 'dart:convert';  // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // For HTTP requests
import 'package:shared_preferences/shared_preferences.dart';

import '../components/home_app_bar.dart';
import '../const.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/profile_drawer.dart';
import 'notification_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late String _userId;
  List<Order> _orders = [];  // List to hold fetched orders
  bool _isLoading = true;  // Loading state

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
    await _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final url = 'https://oac.onrender.com/api/v1/order/user/order';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': _userId}),
      );

      print('${response.statusCode}');
      print('${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final ordersJson = data['orders'] as List<dynamic>;
          setState(() {
            _orders = ordersJson.map((json) {
              final photoData = json['enquiryId']['photo']['data']['data'] as List<dynamic>?;
              final imageBytes = photoData != null ? base64Encode(photoData.cast<int>()) : '';
              final imagePath = photoData != null ? 'data:image/jpeg;base64,$imageBytes' : 'assets/login/welcome.png';

              return Order(
                imagePath: imagePath,
                name: json['enquiryId']['product'] ?? 'Unknown Product',
                price: json['totalPrice']?.toDouble() ?? 0.0,
                size: json['enquiryId']['productSize'] ?? 'Unknown Size',
                quantity : json['enquiryId']['quantity'] ?? 0,
                deliveryDate: json['enquiryId']['expectedDelivery'] ?? 'Unknown Date',
                isDelivered: json['status'] ?? 'Unknown Status',
              );
            }).toList();
            _isLoading = false;
          });
        } else {
          // Handle the case when success is false
          print('Failed to fetch orders: ${data['message']}');
        }
      } else {
        // Handle HTTP error
        print('Failed to fetch orders. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network error
      print('Error fetching orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundPrimary,
      appBar: const CustomNormalAppBar(),
      endDrawer: const NotificationScreen(),
      drawer: const ProfileDrawer(),
      body: SafeArea(
        child: _isLoading
            ? CommonFunction.showLoadingIndicator()
            : SingleChildScrollView(
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
                        icon: const Icon(Icons.login_outlined, color: AppStyles.secondaryTextColor),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 80),
                    const Icon(Icons.shopping_bag, color: AppStyles.primaryTextColor),
                    const SizedBox(width: 4),
                    const Text(
                      'Order',
                      style: AppStyles.headingTextStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    return OrderWidget(order: _orders[index]);
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
  final String deliveryDate;
  final String isDelivered;
  final int quantity;

  Order({
    required this.imagePath,
    required this.name,
    required this.price,
    required this.size,
    required this.deliveryDate,
    required this.isDelivered,
    required this.quantity,
  });


}

class OrderWidget extends StatelessWidget {
  final Order order;

  const OrderWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: AppStyles.backgroundPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            // Display image based on imagePath type
            order.imagePath.startsWith('data:image/jpeg;base64,')
                ? Image.memory(
              base64Decode(order.imagePath.split(',')[1]),
              width: 110,
              height: 140,
              fit: BoxFit.cover,
            )
                : Image.asset(
              'assets/login/welcome.png',
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
                    style: AppStyles.primaryBodyTextStyle,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '\$${order.price.toStringAsFixed(2)}',
                    style: AppStyles.tertiaryBodyTextStyle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.size,
                    style: AppStyles.tertiaryBodyTextStyle,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '${order.isDelivered}\n${order.deliveryDate}',
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
