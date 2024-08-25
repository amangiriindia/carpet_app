import 'package:flutter/material.dart';

import '../const.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/profile_drawer.dart';
import 'notification_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key, }) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List<Order> orders = [
    Order(
      imagePath: 'assets/login/welcome.png',
      name: 'Persian Tabriz',
      price: 29.99,
      size: '151 x 102 cm',
      deliveryDate: 'July 25, 2024',
      isDelivered: true,
    ),
    Order(
      imagePath: 'assets/login/welcome.png',
      name: 'Persian Tabriz',
      price: 49.99,
      size: '151 x 102 cm',
      deliveryDate: 'July 27, 2024',
      isDelivered: false,
    ),
    // Add more orders here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundPrimary ,
      appBar: const CustomAppBar(),
      drawer: const NotificationScreen(),
      endDrawer: const ProfileDrawer(),
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
                        icon: const Icon(Icons.login_outlined,
                            color:AppStyles.secondaryTextColor),
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
  final String deliveryDate;
  final bool isDelivered;

  Order({
    required this.imagePath,
    required this.name,
    required this.price,
    required this.size,
    required this.deliveryDate,
    required this.isDelivered,
  });
}

class OrderWidget extends StatelessWidget {
  final Order order;

  const OrderWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color:AppStyles.backgroundSecondry, // Set the background color of the Card to white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Image.asset(
              order.imagePath,
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
                    style: AppStyles.primaryBodyTextStyle
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '\$${order.price.toStringAsFixed(2)}',
                    style: AppStyles.tertiaryBodyTextStyle
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.size,
                    style: AppStyles.tertiaryBodyTextStyle,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '${order.isDelivered ? 'Delivered On' : 'Delivering On'}:\n${order.deliveryDate}',
                    style: TextStyle(
                      fontSize: 12,
                      color: order.isDelivered ? Colors.black : Colors.green,
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
