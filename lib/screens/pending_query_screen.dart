import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../components/home_app_bar.dart';
import '../constant/const.dart';
import '../components/custom_app_bar.dart';
import 'base/profile_drawer.dart';
import 'base/notification_screen.dart';

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
    CommonFunction.showLoadingDialog(context);
    final url = '${APIConstants.API_URL}api/v1/enquiry/user/enquiry-pending';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"user": _userId}),
    );

    if (response.statusCode == 200) {
      CommonFunction.hideLoadingDialog(context);
      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          orders = (data['enquiries'] as List).map((item) {
            // Ensure 'data' is a List<int>
            List<int> photoData = List<int>.from(item['photo']['data']['data']);
            // Handle the product size logic
            String size = item['customSize']?.isNotEmpty ?? false
                ? item['customSize']
                : item['productSize']['size'] ?? 'Unknown';
            return Order(
              imagePath: 'data:image/jpeg;base64,' + base64Encode(Uint8List.fromList(photoData)),
              name: item['product']['name'] ?? 'Unknown',
              price: item['product']['price']?.toDouble() ?? 0.0,
              // size: item['productSize']['size'] ?? 'Unknown',
              size: size,
            );
          }).toList();
        });
      }
    } else {
      // Handle errors if needed
      CommonFunction.hideLoadingDialog(context);
      print('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomNormalAppBar(),
      endDrawer: const NotificationScreen(),
      drawer: const ProfileDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
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
                  const Icon(Icons.hourglass_empty, color: AppStyles.primaryTextColor),
                  const SizedBox(width: 4),
                  const Text(
                    'Pending Query',
                    style: AppStyles.headingTextStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: orders.isEmpty
                      ? Center(
                    child: Text(
                      'Currently, No Pending Enquiries',
                      style: AppStyles.headingTextStyle.copyWith(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      orders.length,
                          (index) => OrderWidget(order: orders[index]),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
      color: AppStyles.backgroundSecondry,
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
                  const SizedBox(height: 5),
                  Text(
                    '₹${order.price.toStringAsFixed(2)}', // Using INR symbol ₹
                    style: AppStyles.tertiaryBodyTextStyle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.size,
                    style: AppStyles.tertiaryBodyTextStyle,
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      CommonFunction.showToast(context, 'Your enquiry is pending and will be verified soon by our expert.');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppStyles.primaryColorStart),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Pending Query',
                        style: AppStyles.secondaryBodyTextStyle,
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
