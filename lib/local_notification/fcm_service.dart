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
    FirebaseMessaging.onMessage.listen(_handleNotification);
    //Bellow code is work in App Background Notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotification);

    //Bellow message is working in Terminated app
    FirebaseMessaging.onBackgroundMessage(_handleTerminatedMessage);
  }
  static void _handleNotification(RemoteMessage message){
    print(message.data);
    print(message.notification?.title);
    print(message.notification?.body);
  }

  static Future<String?> getToken(){
    return FirebaseMessaging.instance.getToken();
  }
  static void onTokenRefresh(){
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken){
      print(newToken);
      //Call Update token API
    });
  }


}

// Here handle notification on terminated background app
Future<void> _handleTerminatedMessage(RemoteMessage message) async {}
