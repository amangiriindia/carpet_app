import 'dart:convert';  // For JSON decoding
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // For HTTP requests
import 'package:shared_preferences/shared_preferences.dart';

import '../components/home_app_bar.dart';
import '../constant/const.dart';
import '../components/custom_app_bar.dart';
import 'base/profile_drawer.dart';
import 'base/notification_screen.dart';
import 'pageutill/order_details_screen.dart';

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
    final url = '${APIConstants.API_URL}api/v1/order/user/order';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': _userId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final ordersJson = data['orders'] as List<dynamic>;
          setState(() {
            _orders = ordersJson.map((json) {
              final imageData = json['enquiryId']['photo']?['data']?['data'] as List<dynamic>? ?? [];
              final Uint8List imageBytes = Uint8List.fromList(imageData.cast<int>());

              return Order(
                imagePath: imageBytes,  // Use the decoded image bytes
                name: json['enquiryId']['product']['name'] ?? 'Unknown',  // Handle null name
                price: (json['totalPrice'] ?? 0).toDouble(),  // Handle null price
                size: json['enquiryId']['productSize']['size'] ?? 'Unknown',  // Handle null size
                deliveryDate: json['updatedAt'] ?? 'Unknown',  // Handle null delivery date
                isDelivered: json['status'] ?? 'Unknown',    // Handle null delivery status
                quantity: json['enquiryId']['quantity'] ?? 1,  // Handle null quantity
              );
            }).toList();
            _isLoading = false;
          });
        } else {
          print('Failed to fetch orders: ${data['message']}');
        }
      } else {
        print('Failed to fetch orders. Status code: ${response.statusCode}');
      }
    } catch (e) {
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
            : Column(
          children: [
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
            Expanded(  // Use Expanded here to allow scrolling
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  return OrderWidget(order: _orders[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Order {
  final dynamic imagePath;
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderDetailsPage(order: order),
          ),
        );
      },
      child: Card(
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
              order.imagePath is Uint8List
                  ? Image.memory(
                order.imagePath as Uint8List,
                width: 110,
                height: 140,
                fit: BoxFit.contain,
              )
                  : Image.asset(
                'assets/login/welcome.png',
                width: 110,
                height: 140,
                fit: BoxFit.contain,
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
                      '₹${order.price.toStringAsFixed(2)}',
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
      ),
    );
  }
}
