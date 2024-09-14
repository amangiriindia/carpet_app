import 'package:flutter/material.dart';
import 'notification_service.dart';

class TestNotificationPage extends StatelessWidget {
  const TestNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            children: [],
          ),
          ElevatedButton.icon(
            onPressed: () {
              Future.delayed(Duration(seconds: 20)).then((s) {
                NotificationService().showNotification(
                  id: 1,
                  body: "Welcome",
                  payload: "now",
                  title: "New Notificatio",
                );
              });
            },
            label: Text("Show Notification"),
            icon: Icon(Icons.notifications),
          )
        ],
      ),
    );
  }
}
