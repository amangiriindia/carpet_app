import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../components/home_app_bar.dart';
import '../../constant/const.dart';
import '../base/notification_screen.dart';
import '../base/profile_drawer.dart';
import '../order_screen.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundPrimary,
      appBar: const CustomNormalAppBar(),
      endDrawer: const NotificationScreen(),
      drawer: const ProfileDrawer(),
      body: Column(
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
              const Icon(Icons.receipt_long, color: AppStyles.primaryTextColor),
              const SizedBox(width: 4),
              const Text(
                'Order Details',
                style: AppStyles.headingTextStyle,
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display order ID on top
                    Center(
                      child: Text(
                        'Order ID: 66557766565656565', // Example order ID
                        style: AppStyles.primaryBodyTextStyle.copyWith(

                          color: AppStyles.primaryTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Product details section
                    _buildSectionWithTitle('Product Details', Icons.shopping_bag, _buildProductDetails(context)),
                    const SizedBox(height: 30),

                    // User details section
                    _buildSectionWithTitle('User Details', Icons.person, _buildUserDetails()),
                    const SizedBox(height: 30),

                    // Address details section
                    _buildSectionWithTitle('Address Details', Icons.location_on, _buildAddressDetails()),
                    const SizedBox(height: 30),

                    // Price details section
                    _buildSectionWithTitle('Price Details', Icons.monetization_on, _buildPriceDetails()),
                    const SizedBox(height: 30),

                    // Customer support section
                    _buildSectionWithTitle('Customer Support', Icons.support_agent, _buildCustomerSupport()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionWithTitle(String title, IconData icon, Widget content) {
    return Stack(
      children: [
        Container(
          width: double.infinity, // Ensure the container covers the full width
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppStyles.primaryColorEnd, AppStyles.primaryColorStart], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(3), // Set border radius to 3
          ),
          child: Container(
            margin: const EdgeInsets.all(1.5), // Margin to show the gradient
            decoration: BoxDecoration(
              color: AppStyles.backgroundPrimary, // Inner container color
              borderRadius: BorderRadius.circular(2), // Same border radius for inner container
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: content,
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 0,
          child: Container(
            color: AppStyles.backgroundPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(icon, color: AppStyles.secondaryTextColor, size: 18),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: AppStyles.primaryBodyTextStyle.copyWith(
                    fontSize: 16,

                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Product Details with Side by Side Layout
  Widget _buildProductDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Product details on the right
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.name,
                  style: AppStyles.secondaryBodyTextStyle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text('Size: ${order.size}', style: AppStyles.secondaryBodyTextStyle),
                const SizedBox(height: 8),
                Text('Quantity: ${order.quantity}', style: AppStyles.secondaryBodyTextStyle),
                const SizedBox(height: 8),
                Text('Delivery Date: ${order.deliveryDate}', style: AppStyles.secondaryBodyTextStyle),
                const SizedBox(height: 8),
                Text(
                  'Status: ${order.isDelivered}',
                  style: AppStyles.secondaryBodyTextStyle.copyWith(
                    color: order.isDelivered == 'Delivered' ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: order.imagePath is Uint8List
                ? Image.memory(
              order.imagePath as Uint8List,
              width: double.infinity,
              height: 150,
              fit: BoxFit.contain,
            )
                : Image.asset(
              'assets/login/welcome.png',
              width: double.infinity,
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  // User Details
  Widget _buildUserDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${order.firstName} ${order.lastName} ', style: AppStyles.secondaryBodyTextStyle), // Example name
          const SizedBox(height: 8),
          Text('Phone: ${order.mobileNumber}', style: AppStyles.secondaryBodyTextStyle),
          const SizedBox(height: 8),
          Text('Email: ${order.email}', style: AppStyles.secondaryBodyTextStyle),
        ],
      ),
    );
  }

  // Address Details
  Widget _buildAddressDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Street: ${order.street}', style: AppStyles.secondaryBodyTextStyle), // Example address
          const SizedBox(height: 8),
          Text('City: ${order.city}', style: AppStyles.secondaryBodyTextStyle),
          const SizedBox(height: 8),
          Text('State: ${order.state}', style: AppStyles.secondaryBodyTextStyle),
          const SizedBox(height: 8),
          Text('Postal Code: ${order.postalCode}', style: AppStyles.secondaryBodyTextStyle),
          const SizedBox(height: 8),
          Text('Country: ${order.country}', style: AppStyles.secondaryBodyTextStyle),
        ],
      ),
    );
  }

  // Price Details
  Widget _buildPriceDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Price: ₹${order.itemsPrice.toStringAsFixed(2)}', style: AppStyles.secondaryBodyTextStyle),
          const SizedBox(height: 8),
          Text('Tax Price: ₹${order.taxPrice.toStringAsFixed(2)}', style: AppStyles.secondaryBodyTextStyle),
          const SizedBox(height: 8),
          Text('Shipping: ₹${order.shippingPrice.toStringAsFixed(2)}', style: AppStyles.secondaryBodyTextStyle), // Example shipping price
          const SizedBox(height: 8),
          Text(
            'Total: ₹${(order.price + 50).toStringAsFixed(2)}',
            style: AppStyles.secondaryBodyTextStyle.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Customer Support Section
  Widget _buildCustomerSupport() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Need Help?', style: AppStyles.secondaryBodyTextStyle.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.phone, color: AppStyles.secondaryTextColor),
              const SizedBox(width: 10),
              Text(' +91 9876543210', style: AppStyles.secondaryBodyTextStyle),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.email, color: AppStyles.secondaryTextColor),
              const SizedBox(width: 10),
              Text(' support@oacrugs.com', style: AppStyles.secondaryBodyTextStyle),
            ],
          ),
        ],
      ),
    );
  }
}
