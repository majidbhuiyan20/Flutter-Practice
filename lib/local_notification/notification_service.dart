import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  void onDidReceiveNotificationResponse(NotificationResponse response) {
    // Handle notification tap
    // print('Notification tapped: ${response.payload}');
  }

  // Schedule a notification at a specific time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      // Convert to timezone-aware datetime
      final scheduledTZ = tz.TZDateTime.from(scheduledDate, tz.local);
      
      // Ensure the scheduled time is in the future
      if (scheduledTZ.isBefore(tz.TZDateTime.now(tz.local))) {
        throw Exception('Scheduled time must be in the future');
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTZ,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'scheduled_notifications',
            'Scheduled Notifications',
            channelDescription: 'Notifications scheduled for specific times',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } catch (e) {
      throw Exception('Failed to schedule notification: $e');
    }
  }

  // Schedule a reminder notification (15 minutes before the main notification)
  Future<void> scheduleReminderNotification({
    required int reminderId,
    required String title,
    required String body,
    required DateTime mainNotificationTime,
    String? payload,
  }) async {
    try {
      // Calculate reminder time (15 minutes before main notification)
      final reminderTime = mainNotificationTime.subtract(const Duration(minutes: 15));
      
      // Convert to timezone-aware datetime
      final reminderTZ = tz.TZDateTime.from(reminderTime, tz.local);
      
      // Only schedule reminder if it's in the future
      if (reminderTZ.isAfter(tz.TZDateTime.now(tz.local))) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          reminderId,
          'Reminder: $title',
          'Your scheduled event is in 15 minutes',
          reminderTZ,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'reminder_notifications',
              'Reminder Notifications',
              channelDescription: 'Reminder notifications 15 minutes before events',
              importance: Importance.high,
              priority: Priority.high,
              color: Color(0xFF2196F3),
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
        );
      }
    } catch (e) {
      throw Exception('Failed to schedule reminder notification: $e');
    }
  }

  // Schedule both main notification and reminder
  Future<void> scheduleNotificationWithReminder({
    required int mainNotificationId,
    required String title,
    required String body,
    required DateTime scheduledDate,
    bool includeReminder = true,
    String? payload,
  }) async {
    // Schedule main notification
    await scheduleNotification(
      id: mainNotificationId,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      payload: payload,
    );

    // Schedule reminder if requested
    if (includeReminder) {
      await scheduleReminderNotification(
        reminderId: mainNotificationId + 1000, // Use different ID for reminder
        title: title,
        body: body,
        mainNotificationTime: scheduledDate,
        payload: payload,
      );
    }
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    // Also cancel the reminder if it exists
    await flutterLocalNotificationsPlugin.cancel(id + 1000);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  // Show immediate notification (for testing)
  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'immediate_notifications',
          'Immediate Notifications',
          channelDescription: 'Notifications shown immediately',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }
}
