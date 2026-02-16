import 'package:flutter/material.dart';

class LocalNotification extends StatefulWidget {
  const LocalNotification({super.key});

  @override
  State<LocalNotification> createState() => _LocalNotificationState();
}

class _LocalNotificationState extends State<LocalNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
        backgroundColor: Colors.blueAccent,
        title:  Text('Local Notification',style: TextStyle(color: Colors.white, ),),
      ),

    );
  }
}
