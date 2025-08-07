import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class LocalNotification extends StatefulWidget {
  const LocalNotification({super.key});

  @override
  State<LocalNotification> createState() => _LocalNotificationState();
}

class _LocalNotificationState extends State<LocalNotification> {

  ListTile _buildTimaAgoListTile()=>ListTile(
    title: Text("Title"),
    subtitle: Text(timeago.format(DateTime.now())),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Local Notification"),
        leading: Icon(Icons.arrow_back, ),
      ),

      body: Column(
        children: [
          _buildTimaAgoListTile()
        ],
      ),
    );
  }
}
