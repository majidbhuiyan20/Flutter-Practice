import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class LocalNotification extends StatelessWidget {
  const LocalNotification({super.key});

  void showTestNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'test_channel_id', // ID
      'Instant Notifications', // Name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      '🔔 Instant Notification',
      'This is an instant local notification!',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Notification Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: showTestNotification,
          child: Text('Show Notification'),
        ),
      ),
    );
  }
}