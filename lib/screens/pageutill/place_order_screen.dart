import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../const.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/profile_drawer.dart';
import '../notification_screen.dart';
import '../thanks_screen.dart';
import '../welcome_screen.dart';

class ConfirmOrderPage extends StatefulWidget {
  final String enquiryId;
  final String imagePath;
  final String carpetName;
  final String patternName;
  final String size;
  final double price;
  final String shape;
  final String description;
  final double patternPrice;
  final double sizePrice;
  final double gstPercent;
  final double shapePrice;
  final double colorPrice;
  final double shippingPrice;
  final double quantity;

  const ConfirmOrderPage({
    super.key,
    required this.enquiryId,
    required this.imagePath,
    required this.carpetName,
    required this.patternName,
    required this.size,
    required this.price,
    required this.shape,
    required this.description,
    required this.patternPrice,
    required this.sizePrice,
    required this.gstPercent,
    required this.shapePrice,
    required this.colorPrice,
    required this.shippingPrice,
    required this.quantity,
  });

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  late double subtotal=0.0;
  late double gstAmount=0.0;
  late double totalPrice=0.0;
  late String _userId;

  @override
  void initState() {
    super.initState();
    // Calculate initial values
    _loadUserData();
    subtotal = (widget.price + widget.patternPrice + widget.sizePrice + widget.shapePrice + widget.colorPrice) * widget.quantity;
    gstAmount = subtotal * (widget.gstPercent / 100);
    totalPrice = subtotal + gstAmount + widget.shippingPrice;

  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId') ?? '66c4aa81c3e37d9ff6c4be6c';
    // Once userId is loaded, fetch orders


  }

  Future<void> _createOrder(BuildContext context) async {
    CommonFunction.showLoadingDialog(context);
    final String apiUrl = 'https://oac.onrender.com/api/v1/order/create-order';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'enquiryId': widget.enquiryId,
          'paymentMethod': 'Card', // Replace with actual payment method
          'itemsPrice': subtotal,
          'taxPrice': gstAmount,
          'paymentResult': '', // Replace with actual payment result
          'shippingPrice': widget.shippingPrice,
          'totalPrice': totalPrice,
          'userId': _userId, // Replace with actual user ID
          'status': 'Pending',
          'isPaid': true,
          'paidAt': DateTime.now().toIso8601String(),
        }),
      );

      final jsonResponse = jsonDecode(response.body);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 201 && jsonResponse['success']) {
        // Order created successfully
      // Order created successfully
      CommonFunction.hideLoadingDialog(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ThankYouScreen()),
        );
        // Navigate to a different page or show a success dialog
      } else {
        // Failed to create order
        print(jsonResponse['message']);
        CommonFunction.hideLoadingDialog(context);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppStyles.secondaryBodyTextStyle),
        Text(value, style: AppStyles.secondaryBodyTextStyle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Decode base64 string
    Uint8List? decodedImage;
    try {
      if (widget.imagePath.startsWith('data:image/') && widget.imagePath.contains(';base64,')) {
        decodedImage = base64Decode(widget.imagePath.split(',')[1]);
      } else {
        throw FormatException('Invalid image format');
      }
    } catch (e) {
      print('Error decoding image: $e');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      drawer: const NotificationScreen(),
      endDrawer: const ProfileDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed "Order Summary" Section
          Container(
            color: Colors.white,
            child: Row(
              children: [
                const SizedBox(width: 12),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(3.14),
                  child: IconButton(
                    icon: const Icon(Icons.login_outlined, color: AppStyles.secondaryTextColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 80),
                const Icon(Icons.receipt, color: AppStyles.primaryTextColor),
                const SizedBox(width: 4),
                const Text('Order Summary', style: AppStyles.headingTextStyle),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Display
                  if (decodedImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        decodedImage,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    )
                  else
                    const Center(
                      child: Text(
                        'Error loading image',
                        style: AppStyles.tertiaryBodyTextStyle,
                      ),
                    ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      widget.carpetName,
                      style: AppStyles.headingTextStyle,
                    ),
                  ),
                  // Details (Pattern, Size, Shape, Description) in a Dropdown
                  ExpansionTile(
                    title: const Text(
                      'Carpet Details',
                      style: AppStyles.primaryBodyTextStyle,
                    ),
                    children: [
                      Card(
                        color: AppStyles.backgroundSecondry,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Pattern:', widget.patternName),
                              const SizedBox(height: 4),
                              _buildDetailRow('Size:', widget.size),
                              const SizedBox(height: 4),
                              _buildDetailRow('Shape:', widget.shape),
                              const SizedBox(height: 8),
                              Text(
                                widget.description,
                                style: AppStyles.tertiaryBodyTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Card(
                    color: AppStyles.backgroundSecondry,
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Quantity
                          const SizedBox(height: 8),
                          // Price Breakdown Table
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(1),
                            },
                            children: [
                              _buildTableRow('Carpet Price:', '₹${widget.price.toStringAsFixed(2)}'),
                              _buildTableRow('Pattern Price:', '₹${widget.patternPrice.toStringAsFixed(2)}'),
                              _buildTableRow('Size Price:', '₹${widget.sizePrice.toStringAsFixed(2)}'),
                              _buildTableRow('Shape Price:', '₹${widget.shapePrice.toStringAsFixed(2)}'),
                              _buildTableRow('Color Price:', '₹${widget.colorPrice.toStringAsFixed(2)}'),
                              _buildTableRow('Quantity: X', '${widget.quantity.toStringAsFixed(2)}'),
                              TableRow(
                                children: [
                                  const SizedBox(height: 10),
                                  Container(),
                                ],
                              ),
                              _buildTableRow('Subtotal:', '₹${subtotal.toStringAsFixed(2)}'),
                              _buildTableRow('GST (${widget.gstPercent.toStringAsFixed(0)}%):', '₹${gstAmount.toStringAsFixed(2)}'),
                              _buildTableRow('Shipping Price:', '₹${widget.shippingPrice.toStringAsFixed(2)}'),
                            ],
                          ),
                          const Divider(color: Colors.black54),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Price:',
                                  style: AppStyles.primaryBodyTextStyle,
                                ),
                                Text(
                                  '₹${totalPrice.toStringAsFixed(2)}',
                                  style: AppStyles.headingTextStyle
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  const SizedBox(height: 40),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _createOrder(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Confirm Order',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            label,
            style: AppStyles.secondaryBodyTextStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            value,
            style: AppStyles.secondaryBodyTextStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOption(String imagePath, String title) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: 60,
          height: 60,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: AppStyles.tertiaryBodyTextStyle,
        ),
      ],
    );
  }
}
