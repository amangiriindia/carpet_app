import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


// Top-level function for handling background notifications
void backgroundNotificationResponseHandler(NotificationResponse notification) async {
  print('Received background notification response: $notification');
}

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationAndroidSettings = AndroidInitializationSettings('logo');

    final DarwinInitializationSettings initializationSettingIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      defaultPresentSound: true,
      defaultPresentAlert: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        print('Received local notification: $id, $title, $body, $payload');
      },
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationAndroidSettings,
      iOS: initializationSettingIOS,
    );

    await notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: backgroundNotificationResponseHandler,
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    print('Showing notification: $id, $title, $body, $payload');
    await notificationPlugin.show(
      id,
      title,
      body,
      await notificationDetails(),
      payload: payload,
    );
  }

  Future<NotificationDetails> notificationDetails() async {
    return const NotificationDetails(
      iOS: DarwinNotificationDetails(),
      android: AndroidNotificationDetails(
        '454',
        'TestApp',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }
}



