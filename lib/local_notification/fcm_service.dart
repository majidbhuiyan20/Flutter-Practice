import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  //Bellow code is firebase notification service is Initialize and it call from main.dart
  static Future<void> initialize() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    //Bellow code is working on App Foreground Notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.data);
      print(message.notification?.title);
      print(message.notification?.body);
    });
    //Bellow code is work in App Background Notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message.data);
      print(message.notification?.title);
      print(message.notification?.body);
    });

    //Bellow message is working in Terminated app
    FirebaseMessaging.onBackgroundMessage(_handleTerminatedMessage);
  }
}

// Here handle notification on terminated background app
Future<void> _handleTerminatedMessage(RemoteMessage message) async {}
