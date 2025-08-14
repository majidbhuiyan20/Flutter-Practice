import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'notification_service.dart';
import 'notification_model.dart';
import 'add_notification_dialog.dart';

class LocalNotification extends StatefulWidget {
  const LocalNotification({super.key});

  @override
  State<LocalNotification> createState() => _LocalNotificationState();
}

class _LocalNotificationState extends State<LocalNotification> {
  final NotificationService _notificationService = NotificationService();
  List<NotificationModel> scheduledNotifications = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadScheduledNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initializeNotifications();
  }

  Future<void> _loadScheduledNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getStringList('scheduled_notifications') ?? [];
    
    setState(() {
      scheduledNotifications = notificationsJson
          .map((json) => NotificationModel.fromMap(jsonDecode(json)))
          .where((notification) => notification.isInFuture)
          .toList();
    });
  }

  Future<void> _saveScheduledNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = scheduledNotifications
        .map((notification) => jsonEncode(notification.toMap()))
        .toList();
    await prefs.setStringList('scheduled_notifications', notificationsJson);
  }

  Future<void> _addScheduledNotification() async {
    final result = await showDialog<NotificationModel>(
      context: context,
      builder: (context) => const AddNotificationDialog(),
    );

    if (result != null) {
      setState(() {
        isLoading = true;
      });

      try {
        // Validate the scheduled date is in the future
        if (!result.isInFuture) {
          throw Exception('Scheduled time must be in the future');
        }

        // Schedule the notification
        await _notificationService.scheduleNotificationWithReminder(
          mainNotificationId: result.id,
          title: result.title,
          body: result.body,
          scheduledDate: result.scheduledDate,
          includeReminder: result.includeReminder,
          payload: result.payload,
        );

        // Add to local list
        setState(() {
          scheduledNotifications.add(result);
          scheduledNotifications.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
        });

        await _saveScheduledNotifications();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Notification scheduled for ${result.formattedScheduledTime}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error scheduling notification: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _cancelNotification(NotificationModel notification) async {
    try {
      await _notificationService.cancelNotification(notification.id);
      
      setState(() {
        scheduledNotifications.removeWhere((n) => n.id == notification.id);
      });

      await _saveScheduledNotifications();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification cancelled'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cancelling notification: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showTestNotification() async {
    await _notificationService.showImmediateNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Test Notification',
      body: 'This is a test notification!',
    );
  }

  ListTile _buildTimeAgoListTile() => ListTile(
    title: Text("Current Time"),
    subtitle: Text(timeago.format(DateTime.now())),
  );

  Widget _buildScheduledNotificationTile(NotificationModel notification) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          Icons.notifications,
          color: notification.includeReminder ? Colors.blue : Colors.grey,
        ),
        title: Text(notification.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.body),
            const SizedBox(height: 4),
            Text(
              notification.formattedScheduledTime,
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (notification.includeReminder)
              Text(
                'Reminder: 15 minutes before',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.cancel, color: Colors.red),
          onPressed: () => _cancelNotification(notification),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Local Notifications"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadScheduledNotifications,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildTimeAgoListTile(),
                const Divider(),
                Expanded(
                  child: scheduledNotifications.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No scheduled notifications',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: scheduledNotifications.length,
                          itemBuilder: (context, index) {
                            return _buildScheduledNotificationTile(
                              scheduledNotifications[index],
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'test',
            onPressed: _showTestNotification,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.notifications_active),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'testAll',
            onPressed: () async {
              final now = DateTime.now();
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              
              try {
                // Immediate notification
                await _notificationService.showImmediateNotification(
                  id: now.millisecondsSinceEpoch,
                  title: 'Immediate Notification',
                  body: 'This is an immediate notification.',
                );
                // Scheduled notification (1 min from now)
                final scheduledId = now.millisecondsSinceEpoch + 1;
                await _notificationService.scheduleNotification(
                  id: scheduledId,
                  title: 'Scheduled Notification',
                  body: 'This notification is scheduled for 1 minute from now.',
                  scheduledDate: now.add(const Duration(minutes: 1)),
                );
                // Reminder notification (45 sec from now, for a main notification 16 min from now)
                final reminderId = now.millisecondsSinceEpoch + 2;
                await _notificationService.scheduleReminderNotification(
                  reminderId: reminderId,
                  title: 'Reminder Notification',
                  body: 'This is a reminder notification (15 min before event).',
                  mainNotificationTime: now.add(const Duration(minutes: 16)),
                );
                
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('All notification types have been triggered for testing.'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Error testing notifications: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            backgroundColor: Colors.purple,
            child: const Icon(Icons.science),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: _addScheduledNotification,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
