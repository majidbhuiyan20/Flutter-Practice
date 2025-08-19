# Local Notification System

This folder contains a comprehensive local notification system with scheduled notifications and reminder functionality.

## Features

### 1. Scheduled Notifications
- Schedule notifications for specific dates and times
- Notifications will appear at the exact time you set
- Support for custom titles and messages

### 2. Reminder Notifications
- Automatic reminder notifications 15 minutes before the main notification
- Toggle to enable/disable reminders
- Different notification channel for reminders (blue color)

### 3. Notification Management
- View all scheduled notifications
- Cancel individual notifications
- Cancel all notifications
- Test immediate notifications

## Files Structure

- `notification_service.dart` - Core notification service with scheduling logic
- `notification_model.dart` - Data model for notification objects
- `local_notification.dart` - Main UI screen for managing notifications
- `add_notification_dialog.dart` - Dialog for adding new scheduled notifications

## Usage

### Adding a Scheduled Notification

1. Tap the blue "+" floating action button
2. Fill in the notification details:
   - **Title**: The notification title
   - **Message**: The notification body text
   - **Date**: Select the date for the notification
   - **Time**: Select the time for the notification
   - **Include Reminder**: Toggle to enable 15-minute reminder

3. Tap "Schedule" to create the notification

### Features

- **Date/Time Picker**: Easy selection of notification time
- **Validation**: Ensures notifications are scheduled for future times
- **Reminder Toggle**: Control whether to include 15-minute reminders
- **Persistent Storage**: Notifications are saved and restored on app restart
- **Real-time Updates**: Current time display with timeago formatting

### Notification Types

1. **Main Notification**: Appears at the scheduled time
2. **Reminder Notification**: Appears 15 minutes before the main notification (if enabled)
3. **Test Notification**: Immediate notification for testing purposes
4. **Test All Notifications**: Triggers all three types for comprehensive testing

### UI Elements

- **Current Time**: Shows the current time with timeago formatting
- **Notification List**: Displays all scheduled notifications with details
- **Cancel Button**: Remove individual notifications
- **Refresh Button**: Reload notifications from storage
- **Test Button**: Send immediate test notification
- **Test All Button**: Trigger all notification types (immediate, scheduled, reminder)
- **Add Button**: Create new scheduled notification

## Technical Details

### Dependencies
- `flutter_local_notifications`: Core notification functionality
- `timezone`: Timezone support for accurate scheduling
- `shared_preferences`: Local storage for notification data
- `timeago`: Time formatting for UI

### Notification Channels
- **Scheduled Notifications**: Main notifications at scheduled times
- **Reminder Notifications**: 15-minute advance reminders
- **Immediate Notifications**: Test notifications

### Storage
Notifications are stored locally using SharedPreferences and persist across app restarts.

### Permissions
The app requests notification permissions on iOS and uses default Android permissions.
