import 'package:flutter/material.dart';
import 'order_screen.dart';

class ApprovedQueryScreen extends StatefulWidget {
  const ApprovedQueryScreen({super.key});

  @override
  State<ApprovedQueryScreen> createState() => _ApprovedQueryScreenState();
}

class _ApprovedQueryScreenState extends State<ApprovedQueryScreen> {
  final List<Order> orders = [
    Order(
      imagePath: 'assets/login/welcome.png',
      name: 'Persian Tabriz',
      price: 29.99,
      size: '151 x 102 cm',
    ),
    Order(
      imagePath: 'assets/login/welcome.png',
      name: 'Persian Tabriz',
      price: 49.99,
      size: '151 x 102 cm',
    ),
  ];
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
                        icon: const Icon(Icons.login_outlined,
                            color: Colors.black54),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 80),
                    const Icon(Icons.list_alt_outlined, color: Colors.black54),
                    const SizedBox(width: 4),
                    const Text(
                      'Approved Query',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${order.price.toStringAsFixed(2)}',
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
