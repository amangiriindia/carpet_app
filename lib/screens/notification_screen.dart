import 'package:OACrugs/const.dart';
import 'package:OACrugs/screens/pageutill/home_title_heading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // For loading indicator

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? _userId;
  List<dynamic> _notifications = [];
  bool _isLoading = true;

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
    setState(() {
      _isLoading = true;
    });

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
        _isLoading = false;
      });
    } else {
      // Handle errors here
      setState(() {
        _isLoading = false;
      });
      print('Failed to load notifications');
    }
  }

  Widget buildNotificationCard({
    required IconData iconData,
    required String title,
    required String description,
    required bool status,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
      child: Card(
        color: AppStyles.backgroundSecondry,
        elevation: 1, // Add elevation for a modern shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15), // Apply the same border radius
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  iconData,
                  size: 28, // Slightly larger icon for emphasis
                  color: status ? AppStyles.successColor : AppStyles.errorColor, // Modern color for status
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppStyles.primaryBodyTextStyle.copyWith(
                          fontWeight: FontWeight.bold, // Bold for emphasis
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3), // Spacing between title and description
                      Text(
                        description,
                        style: AppStyles.secondaryBodyTextStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppStyles.backgroundPrimary,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 70.0), // Adjust the value to your needs
            child: SectionTitle(title: "Notification"),
          ),

          const Divider(height: 1),
          _isLoading
              ? Center(
            child: SpinKitThreeBounce(
              color: AppStyles.primaryColorStart,
              size: 20.0,
            ),
          )
              : _notifications.isEmpty
              ? const Center(
            child: Text(
              'No notifications available',
              style: AppStyles.tertiaryBodyTextStyle,
            ),
          )
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final notification = _notifications[index];
              final bool status = notification['type'] ?? false;

              return Column(
                children: [
                  buildNotificationCard(
                    iconData: Icons.notifications,
                    title: notification['message'] ?? 'No Title',
                    description:
                    notification['description'] ?? 'No Description',
                    status: status,
                    onTap: () {
                      // Handle notification tap
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
