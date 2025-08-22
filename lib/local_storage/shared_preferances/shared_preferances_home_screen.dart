import 'package:flutter/material.dart';

class SharedPreferencesHomeScreen extends StatefulWidget {
  const SharedPreferencesHomeScreen({super.key});

  @override
  State<SharedPreferencesHomeScreen> createState() => _SharedPreferencesHomeScreen();
}

class _SharedPreferencesHomeScreen extends State<SharedPreferencesHomeScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text("Shared Preferences", style: TextStyle(color: Colors.white),),
            leading: BackButton(color: Colors.white,),
          ),
    );
  }
}
