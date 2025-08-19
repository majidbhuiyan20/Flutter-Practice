class NotificationModel {
  final int id;
  final String title;
  final String body;
  final DateTime scheduledDate;
  final bool includeReminder;
  final String? payload;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledDate,
    this.includeReminder = true,
    this.payload,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'scheduledDate': scheduledDate.millisecondsSinceEpoch,
      'includeReminder': includeReminder,
      'payload': payload,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Create from Map
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      scheduledDate: DateTime.fromMillisecondsSinceEpoch(map['scheduledDate']),
      includeReminder: map['includeReminder'] ?? true,
      payload: map['payload'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  // Copy with method
  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? scheduledDate,
    bool? includeReminder,
    String? payload,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      includeReminder: includeReminder ?? this.includeReminder,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Check if notification is in the future
  bool get isInFuture => scheduledDate.isAfter(DateTime.now());

  // Get time until notification
  Duration get timeUntilNotification {
    final now = DateTime.now();
    if (scheduledDate.isAfter(now)) {
      return scheduledDate.difference(now);
    }
    return Duration.zero;
  }

  // Get formatted time string
  String get formattedScheduledTime {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduledDay = DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day);
    
    if (scheduledDay.isAtSameMomentAs(today)) {
      return 'Today at ${_formatTime(scheduledDate)}';
    } else if (scheduledDay.isAtSameMomentAs(today.add(const Duration(days: 1)))) {
      return 'Tomorrow at ${_formatTime(scheduledDate)}';
    } else {
      return '${_formatDate(scheduledDate)} at ${_formatTime(scheduledDate)}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    return '$day/$month/$year';
  }
}
