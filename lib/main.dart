import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/router/app_routes.dart'; // Assuming this file exists and is needed. If not, remove this line.

import 'firebase_options.dart';
import 'local_notification/local_notification.dart';

final navigatorKey = GlobalKey<NavigatorState>();
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Timezone
 // tz.initializeTimeZones();
  //tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));

  // Initialize Plugin
  // const AndroidInitializationSettings initializationSettingsAndroid =
  // AndroidInitializationSettings('@mipmap/ic_launcher');

  // const InitializationSettings initializationSettings =
  // InitializationSettings(android: initializationSettingsAndroid);

 // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(

      // GlobalKey<NavigatorState>()
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,

      ),
      routerConfig: router,

    );
  }
}