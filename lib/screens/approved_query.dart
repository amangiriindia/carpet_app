import 'package:OACrugs/screens/pageutill/place_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../components/home_app_bar.dart';
import '../const.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/profile_drawer.dart';
import 'notification_screen.dart';

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

    CommonFunction.showLoadingDialog(context);
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

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      CommonFunction.hideLoadingDialog(context);
      final data = json.decode(response.body);
      if (data['success']) {
        try {
          setState(() {
            orders = (data['enquiries'] as List).map((item) {
              // Debugging
              print(item);

              // Ensure `item['photo']['data']['data']` is a List<int>
              final photoData = item['photo']['data']['data'];
              List<int> photoBytes;

              if (photoData is List) {
                // Convert List<dynamic> to List<int>
                photoBytes = List<int>.from(photoData);
              } else if (photoData is String) {
                // Handle case where photoData is a Base64 string
                photoBytes = base64Decode(photoData);
              } else {
                // Handle unexpected type
                photoBytes = [];
                print('Unexpected type for photoData: ${photoData.runtimeType}');
              }

              return Order(
                enquiryId: item['_id'] ?? 'Unknown',
                imagePath: 'data:image/jpeg;base64,' + base64Encode(Uint8List.fromList(photoBytes)),
                carpetName: item['product']['name'] ?? 'Unknown',
                patternName: item['patternId']['name'] ?? 'Unknown',
                patternPrice: (item['patternId']['collectionPrice'] ?? 0.0).toDouble(),
                size: item['productSize']['size'] ?? 'Unknown',
                sizePrice: (item['productSize']['sizePrice'] ?? 0.0).toDouble(),
                price: (item['product']['price'] ?? 0.0).toDouble(),
                gstPrecent: (item['product']['gst'] ?? 0.0).toDouble(),
                shape: item['shape']['shape'] ?? 'Unknown',
                shapePrice: (item['shape']['shapePrice'] ?? 0.0).toDouble(),
                //colorPrice: (item['productColor']['colorPrice'] ?? 0.0).toDouble(),
                  colorPrice: (item['productSize']['sizePrice'] ?? 0.0).toDouble(),
                description: item['product']['description'] ?? 'No description available',
                shippingPrice: (item['shippingPrice'] ?? 0.0).toDouble(),
                quantity: (item['quantity'] ?? 0.0).toDouble(),
              );
            }).toList();
          });
        } catch (e) {
          print('Error parsing orders: $e');
        }
      }
    } else {
      CommonFunction.hideLoadingDialog(context);
      print('Failed to load orders');
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                    const Icon(Icons.check_circle_outline, color: AppStyles.primaryTextColor),
                    const SizedBox(width: 4),
                    const Text(
                      'Approved Query',
                      style: AppStyles.headingTextStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                orders.isEmpty
                    ? Center(
                  child: Text(
                    'Awaiting Approved Enquiries',
                    style: AppStyles.headingTextStyle.copyWith(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true, // Use this property to limit the height
                  physics: const NeverScrollableScrollPhysics(), // Disable scrolling
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
  final double patternPrice;
  final double quantity;
  final String size;
  final double sizePrice;
  final double price;
  final double gstPrecent;
  final String shape;
  final double shapePrice;
  final double colorPrice;
  final String description;
  final double shippingPrice;

  Order({
    required this.enquiryId,
    required this.imagePath,
    required this.carpetName,
    required this.patternName,
    required this.patternPrice,
    required this.size,
    required this.sizePrice,
    required this.price,
    required this.gstPrecent,
    required this.shape,
    required this.shapePrice,
    required this.colorPrice,
    required this.description,
    required this.shippingPrice,
    required this.quantity,
  });
}

class OrderWidget extends StatelessWidget {
  final Order order;

  const OrderWidget({super.key, required this.order});

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
            // Display image with error handling
            Image.memory(
              base64Decode(order.imagePath.split(',')[1]),
              width: 130,
              height: 140,
              fit: BoxFit.contain,
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
                    style: AppStyles.primaryBodyTextStyle,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '₹${order.price.toStringAsFixed(2)}',
                    style: AppStyles.tertiaryBodyTextStyle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.size,
                    style: AppStyles.tertiaryBodyTextStyle,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Text(
                        'Approved',
                        style: AppStyles.primaryBodyTextStyle.copyWith(
                          color: Colors.green, // Set the color to green
                        ),
                      ),
                      const SizedBox(width: 15),
                      InkWell(onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmOrderPage(
                              enquiryId: order.enquiryId,
                              imagePath: order.imagePath,
                              carpetName: order.carpetName,
                              patternName: order.patternName,
                              patternPrice: order.patternPrice, // Added field
                              size: order.size,
                              sizePrice: order.sizePrice,       // Added field
                              price: order.price,
                              gstPercent: order.gstPrecent,      // Added field
                              shape: order.shape,
                              shapePrice: order.shapePrice,     // Added field
                              colorPrice: order.colorPrice,     // Added field
                              description: order.description,
                              shippingPrice:order.shippingPrice,
                                quantity:order.quantity,
                            ),
                          ),
                        );
                      },


                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppStyles.primaryTextColor),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Finalize Order',
                            style: AppStyles.secondaryBodyTextStyle,
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