// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
// class LocalNotification extends StatefulWidget {
//   const LocalNotification({super.key});
//
//   @override
//   State<LocalNotification> createState() => _LocalNotificationState();
// }
//
// class _LocalNotificationState extends State<LocalNotification> {
//   TimeOfDay? _selectedTime;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
//   }
//
//   Future<void> _initializeNotifications() async {
//     tz.initializeTimeZones(); // Initialize time zones
//
//     const AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: androidInitializationSettings);
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void> _showInstantNotification() async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'instant_channel_id', // Unique ID for the instant notification channel
//       'Instant Notifications', // Name of the channel
//       channelDescription: 'Channel for instant notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidDetails);
//
//     await flutterLocalNotificationsPlugin.show(
//       0, // Notification ID
//       '🚀 Instant Notification!',
//       'This is an immediate notification.',
//       notificationDetails,
//     );
//   }
//
//   Future<void> _scheduleNotification() async {
//     // Initialize timezones if not done already
//     tz.initializeTimeZones();
//
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'scheduled_channel_id',
//       'Scheduled Notifications',
//       channelDescription: 'Channel for scheduled notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidDetails);
//
//     final now = tz.TZDateTime.now(tz.local);
//
//     // Default time if _selectedTime is null
//     final int scheduledHour = _selectedTime?.hour ?? 10;
//     final int scheduledMinute = _selectedTime?.minute ?? 30;
//
//     // Create the scheduled datetime
//     tz.TZDateTime scheduledDate = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       scheduledHour,
//       scheduledMinute,
//     );
//
//     // If the time has already passed for today, schedule for tomorrow
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       1,
//       '⏰ Scheduled Notification',
//       'Reminder set for ${scheduledDate.hour.toString().padLeft(2, '0')}:${scheduledDate.minute.toString().padLeft(2, '0')}',
//       scheduledDate,
//       notificationDetails,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
//
//
//
//   Future<void> _scheduleNotificationAtSelectedTime() async {
//     if (_selectedTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a time first!')),
//       );
//       return;
//     }
//
//     // Ensure time zones are initialized
//     if (tz.timeZoneDatabase.locations.isEmpty) {
//       tz.initializeTimeZones();
//     }
//
//     final now = tz.TZDateTime.now(tz.local);
//
//     // Set notification time for today with the selected hour and minute
//     tz.TZDateTime scheduledDate = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       _selectedTime!.hour,
//       _selectedTime!.minute,
//     );
//
//     // If the selected time has passed, schedule for next day
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//
//     const androidDetails = AndroidNotificationDetails(
//       'user_scheduled_channel_id',
//       'User Scheduled Notifications',
//       channelDescription: 'Channel for notifications scheduled by the user',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const notificationDetails = NotificationDetails(android: androidDetails);
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       2, // Notification ID
//       '🔔 User Scheduled Notification',
//       'This notification was scheduled for ${_selectedTime!.format(context)}.',
//       scheduledDate,
//       notificationDetails,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // ✅ New in 17.0.0+
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, // Optional if repeating daily
//     );
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Notification scheduled for ${_selectedTime!.format(context)}'),
//       ),
//     );
//   }
//
//
//
//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime ?? TimeOfDay.now(),
//     );
//     if (picked != null && picked != _selectedTime) {
//       setState(() {
//         _selectedTime = picked;
//       });
//     }
//   }
//
//   Future<void> _scheduleNotificationBeforeSelectedTime(int minutesBefore) async {
//     if (_selectedTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a time first!')),
//       );
//       return;
//     }
//
//     if (tz.timeZoneDatabase.locations.isEmpty) {
//       tz.initializeTimeZones();
//     }
//
//     final now = tz.TZDateTime.now(tz.local);
//     final scheduledDate = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       _selectedTime!.hour,
//       _selectedTime!.minute,
//     );
//
//     final notificationTime = scheduledDate.subtract(Duration(minutes: minutesBefore));
//
//     if (notificationTime.isBefore(now)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Notification time already passed! Please select a later time.')),
//       );
//       return;
//     }
//
//     const androidDetails = AndroidNotificationDetails(
//       'user_scheduled_channel_id',
//       'User Scheduled Notifications',
//       channelDescription: 'Channel for notifications scheduled by the user',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const notificationDetails = NotificationDetails(android: androidDetails);
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       3, // Unique notification ID
//       '🔔 Reminder',
//       'Your event starts in $minutesBefore minutes!',
//       notificationTime,
//       notificationDetails,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     );
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Notification scheduled $minutesBefore minutes before selected time')),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     TimeOfDay? selectedTime;
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Flutter Local Notifications')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _showInstantNotification,
//               child: const Text('Show Instant Notification'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _selectTime(context),
//               child: Text(_selectedTime == null
//                   ? 'Select Time for Notification'
//                   : 'Change Time: ${_selectedTime!.format(context)}'),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: selectedTime != null
//                   ? _scheduleNotificationAtSelectedTime
//                   : null,
//               child: const Text('Schedule Notification at Selected Time'),
//             ),
//             ElevatedButton(
//               onPressed: _selectedTime != null
//                   ? () => _scheduleNotificationBeforeSelectedTime(3)
//                   : null,
//               child: const Text('Notify 3 Minutes Before'),
//             ),
//
//             const SizedBox(height: 10),
//
//             ElevatedButton(
//               onPressed: _selectedTime != null
//                   ? () => _scheduleNotificationBeforeSelectedTime(40)
//                   : null,
//               child: const Text('Notify 40 Minutes Before'),
//             ),
//
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _selectedTime != null
//                   ? () => _scheduleNotificationBeforeSelectedTime(30)
//                   : null,
//               child: const Text('Notify 30 Minutes Before Meeting'),
//             ),
//
//
//
//           ],
//
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _scheduleNotification,
//         child: const Icon(Icons.alarm),
//       ),
//     );
//   }
// }