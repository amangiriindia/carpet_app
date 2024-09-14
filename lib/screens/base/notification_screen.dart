import 'dart:async';
import 'package:OACrugs/components/home_title_heading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // For loading indicator
import '../../constant/const.dart';
import '../../test/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}


class _NotificationScreenState extends State<NotificationScreen> {
  String? _userId;
  List<dynamic> _notifications = [];
  bool _isLoading = true;
  Timer? _timer; // Timer for periodic polling

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _startPolling(); // Start polling for notifications
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '66c4aa81c3e37d9ff6c4be6c';
    });
    _fetchNotifications();
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      // Poll every 30 seconds for new notifications
      await _fetchNotifications();
    });
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
    });

    final url = '${APIConstants.API_URL}api/v1/notification/user/notification';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"userId": _userId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> newNotifications = data['notifications'];

      setState(() {
        _notifications = newNotifications;
        _isLoading = false;
      });

      // Check if there are new notifications
      for (var notification in newNotifications) {
        // Replace with your logic to determine if it's a new notification
        if (notification['isNew'] == true) {
          NotificationService().showNotification(
            id: notification['id'],
            body: notification['description'] ?? 'No Description',
            payload: 'now',
            title: notification['message'] ?? 'New Notification',
          );
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Failed to load notifications');
    }
  }



  void _showNotificationDetails(dynamic notification) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Custom close button on top right (adjusted positioning)
              Positioned(
                right: 10.0, // Adjust right padding for desired centering
                top: 10.0, // Adjust top padding for desired centering
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.black), // Built-in close icon
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: 10),
              Text(notification['message'] ?? 'No Title', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(notification['description'] ?? 'No Description', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              // Add more details here if available
            ],
          ),
        );
      },
    );
  }

  Widget buildNotificationCard({
    required IconData iconData,
    required String title,
    required String description,
    required bool status,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Card(
        color: Colors.white,
        elevation: 5, // Slightly elevated for modern shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12), // Apply the same border radius
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: status ? AppStyles.successColor.withOpacity(0.2) : AppStyles.errorColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    iconData,
                    size: 30, // Slightly larger icon for emphasis
                    color: status ? AppStyles.successColor : AppStyles.errorColor, // Modern color for status
                  ),
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
                      const SizedBox(height: 4), // Spacing between title and description
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
                    description: notification['description'] ?? 'No Description',
                    status: status,
                    onTap: () {
                      _showNotificationDetails(notification);
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
