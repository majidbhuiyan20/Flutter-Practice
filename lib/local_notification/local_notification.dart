import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Notifications Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LocalNotification(),
    );
  }
}

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
        title: const Text("Local Notification", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.notifications_active, size: 100, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'Local Notifications Demo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Try the different notification options below',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Simple notification button
              ElevatedButton.icon(
                onPressed: () => showInstantNotification(
                  id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                  title: 'Hello!',
                  body: 'This is an instant notification',
                ),
                icon: const Icon(Icons.notifications),
                label: const Text('Show Notification'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 10),
              // Scheduled notification button
              ElevatedButton.icon(
                onPressed: () => scheduleReminder(
                  id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                  title: 'Scheduled Notification',
                  body: 'This was scheduled 5 seconds ago',
                ),
                icon: const Icon(Icons.schedule),
                label: const Text('Schedule in 5 Seconds'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 10),
              // Notification with action buttons
              ElevatedButton.icon(
                onPressed: () => showNotificationWithActions(
                  id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                  title: 'Action Notification',
                  body: 'This notification has action buttons',
                ),
                icon: const Icon(Icons.touch_app),
                label: const Text('Notification with Actions'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final FlutterLocalNotificationsPlugin notificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  // Initialize timezone
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  // Initialize notification plugin
  const AndroidInitializationSettings androidSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await notificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle when a notification is tapped
      debugPrint('Notification tapped: ${response.payload}');
    },
  );
}

Future<void> showInstantNotification({
  required int id,
  required String title,
  required String body,
  String? payload,
}) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'instant_channel',
    'Instant Notifications',
    channelDescription: 'Channel for showing instant notifications',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
  );

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await notificationsPlugin.show(
    id,
    title,
    body,
    notificationDetails,
    payload: payload,
  );
}

Future<void> scheduleReminder({
  required int id,
  required String title,
  String? body,
  String? payload,
}) async {
  final scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'scheduled_channel',
    'Scheduled Notifications',
    channelDescription: 'Channel for scheduled notifications',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await notificationsPlugin.zonedSchedule(
    id,
    title,
    body ?? '',
    scheduledDate,
    notificationDetails,
    // androidAllowWhileIdle: true,
    // uiLocalNotificationDateInterpretation:
    // UILocalNotificationDateInterpretation.absoluteTime,
    payload: payload, androidScheduleMode: AndroidScheduleMode.exact,
  );
}

Future<void> showNotificationWithActions({
  required int id,
  required String title,
  required String body,
}) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'actions_channel',
    'Notifications with Actions',
    channelDescription: 'Channel for notifications with action buttons',
    importance: Importance.high,
    priority: Priority.high,
    actions: [
      AndroidNotificationAction(
        'reply',
        'Reply',
        showsUserInterface: true,
      ),
      AndroidNotificationAction(
        'dismiss',
        'Dismiss',
       // destructive: true,
      ),
    ],
  );

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await notificationsPlugin.show(
    id,
    title,
    body,
    notificationDetails,
  );
}