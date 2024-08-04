import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  Widget buildListTile({
    required IconData iconData,
    required String title,
    required String orderNumber,
    required String description,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10), // Space above the icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 6.0),
                child: Icon(iconData, size: 24),
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 50.0,top: 10),
        child: Text(
          '$orderNumber\n$description',
          style: const TextStyle(fontSize: 14),
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 120, bottom: 40),
            color: Colors.white10,
            child: const Center(
              child: Text(
                'Notification',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          buildListTile(
            iconData: Icons.list_outlined,
            title: 'Orders',
            orderNumber: 'Order #12345',
            description: 'Your order has been shipped',
            onTap: () {
              // Update the state of the app
            },
          ),
          const Divider(height: 1), // Reduced height of Divider
          buildListTile(
            iconData: Icons.checklist_outlined,
            title: 'Approved Query',
            orderNumber: 'Order #12346',
            description: 'Your order has been approved',
            onTap: () {
              // Update the state of the app
            },
          ),
          const Divider(height: 1), // Reduced height of Divider
        ],
      ),
    );
  }
}
