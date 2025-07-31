import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotification extends StatefulWidget {
  const LocalNotification({super.key});

  @override
  State<LocalNotification> createState() => _LocalNotificationState();
}

class _LocalNotificationState extends State<LocalNotification> {
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones(); // Initialize time zones

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showInstantNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'instant_channel_id', // Unique ID for the instant notification channel
      'Instant Notifications', // Name of the channel
      channelDescription: 'Channel for instant notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      '🚀 Instant Notification!',
      'This is an immediate notification.',
      notificationDetails,
    );
  }

  Future<void> _scheduleNotification() async {
    // Ensure timezone is initialized before scheduling:
    if (tz.timeZoneDatabase.locations.isEmpty) {
      tz.initializeTimeZones(); // Make sure this is called if not already done in initState
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'scheduled_channel_id', // Unique ID for the scheduled notification channel
      'Scheduled Notifications', // Name of the channel
      channelDescription: 'Channel for scheduled notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));


    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      '⏰ Scheduled Notification',
      'This notification was scheduled 5 seconds ago!',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Local Notifications')),
      body: Center(
        child: ElevatedButton(
          onPressed: _showInstantNotification,
          child: const Text('Show Instant Notification'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scheduleNotification,
        child: const Icon(Icons.alarm),
      ),
    );
  }
}