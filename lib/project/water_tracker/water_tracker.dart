import 'package:flutter/material.dart';

class WaterTracker extends StatefulWidget {
  const WaterTracker({super.key});

  @override
  State<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Tracker', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        leading: BackButton(
          color: Colors.white,
        ),
      ),


    );
  }
}
