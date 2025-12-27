import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService{
  static Future<void> initialize() async{
    await FirebaseMessaging.instance.requestPermission(
       alert : true,
       announcement : false,
       badge : true,
       carPlay : false,
       criticalAlert : false,
       provisional : false,
       sound : true,

    );

  }
}
