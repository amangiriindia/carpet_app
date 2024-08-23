import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? _userId;
  List<dynamic> _notifications = [];

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
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final url = 'https://oac.onrender.com/api/v1/notification/user/notification';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"userId": _userId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _notifications = data['notifications'];
      });
    } else {
      // Handle errors here
      print('Failed to load notifications');
    }
  }

  Widget buildListTile({
    required IconData iconData,
    required String title,
    required String description,
    required bool status, // Add a status parameter to control the icon color
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      title: Row(
        children: [
          Icon(
            iconData,
            size: 24,
            color: status ? Colors.green : Colors.red, // Color based on status
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis, // Handle long text
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 44.0, top: 10),
        child: Text(
          description,
          style: const TextStyle(fontSize: 14),
          maxLines: 2, // Limit description to 2 lines
          overflow: TextOverflow.ellipsis,
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
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            color: Colors.white10,
            child: const Center(
              child: Text(
                'Notification',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          const Divider(height: 1),
          _notifications.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            shrinkWrap: true, // Use shrinkWrap to limit the size within the Drawer
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling in the ListView
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final notification = _notifications[index];
              final bool status = notification['type'] ?? false; // Use the 'type' field for status

              return Column(
                children: [
                  buildListTile(
                    iconData: Icons.notifications,
                    title: notification['message'] ?? 'No Title',
                    description: notification['description'] ?? 'No Description',
                    status: status,
                    onTap: () {
                      // Handle notification tap
                    },
                  ),
                  const Divider(height: 1), // Reduced height of Divider
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
