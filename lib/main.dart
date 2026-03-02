import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:practice/local_notification/fcm_service.dart';
import 'package:practice/router/app_routes.dart';
import 'firebase_options.dart';


final navigatorKey = GlobalKey<NavigatorState>();
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = "pk_test_51SgJzGEHj0qFa8VvPDTSGUhtZOtJSpsdEwURn7HryyN5Z13LymeJ2nhhxlcEWnncUqYwJAt4fX7U6rlfphP6qqqu00ZNmys0G8";;



  await Stripe.instance.applySettings();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FCMService.initialize();

  print("build");
  //print(await FCMService.getToken());
  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widgets is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

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