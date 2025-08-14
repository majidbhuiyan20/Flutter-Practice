import 'package:flutter/material.dart';
import 'package:practice/firebase/firebase_services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices splashScreen = SplashServices();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blueAccent, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.flutter_dash, size: 100, color: Colors.white), // Centered icon
            SizedBox(height: 20),
            Text("Majid Firebase Auth", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)), // App name
            // You can add a progress indicator here if needed
          ],
        ),
      ),
    );
  }
}
