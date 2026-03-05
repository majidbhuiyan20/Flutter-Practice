import 'package:flutter/material.dart';
class Hisabi extends StatefulWidget {
  const Hisabi({super.key});

  @override
  State<Hisabi> createState() => _HisabiState();
}

class _HisabiState extends State<Hisabi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
    );
  }
}
