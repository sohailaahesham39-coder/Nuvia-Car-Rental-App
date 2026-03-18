class Notification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? actionType; // 'open_booking', 'open_car', etc.
  final String? actionData; // ID or data related to the action
  final String? imageUrl;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    required this.isRead,
    this.actionType,
    this.actionData,
    this.imageUrl,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      type: NotificationType.values.firstWhere(
            (e) => e.toString() == 'NotificationType.${json['type']}',
        orElse: () => NotificationType.general,
      ),
      isRead: json['isRead'] ?? false,
      actionType: json['actionType'],
      actionData: json['actionData'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'isRead': isRead,
      'actionType': actionType,
      'actionData': actionData,
      'imageUrl': imageUrl,
    };
  }

  Notification copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
    String? actionType,
    String? actionData,
    String? imageUrl,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      actionType: actionType ?? this.actionType,
      actionData: actionData ?? this.actionData,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

enum NotificationType {
  booking,       // Related to bookings (confirmation, cancellation, etc.)
  payment,       // Payment related notifications
  promotion,     // Promotions and offers
  system,        // System notifications (maintenance, app updates)
  reminder,      // Reminders (upcoming booking, return car)
  general,       // General notifications
}

class NotificationSettings {
  final bool enablePush;
  final bool enableEmail;
  final bool enableSMS;
  final Map<NotificationType, bool> typeSettings;
  final bool enableBookingUpdates;
  final bool enablePromotions;
  final bool enableSystemNotifications;
  final TimeOfDay? quietHoursStart;
  final TimeOfDay? quietHoursEnd;

  NotificationSettings({
    required this.enablePush,
    required this.enableEmail,
    required this.enableSMS,
    required this.typeSettings,
    required this.enableBookingUpdates,
    required this.enablePromotions,
    required this.enableSystemNotifications,
    this.quietHoursStart,
    this.quietHoursEnd,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    Map<NotificationType, bool> typeSettingsMap = {};

    if (json['typeSettings'] != null) {
      json['typeSettings'].forEach((key, value) {
        final type = NotificationType.values.firstWhere(
              (e) => e.toString() == 'NotificationType.$key',
          orElse: () => NotificationType.general,
        );

        typeSettingsMap[type] = value;
      });
    } else {
      // Default all notification types to true if not specified
      for (var type in NotificationType.values) {
        typeSettingsMap[type] = true;
      }
    }

    return NotificationSettings(
      enablePush: json['enablePush'] ?? true,
      enableEmail: json['enableEmail'] ?? true,
      enableSMS: json['enableSMS'] ?? false,
      typeSettings: typeSettingsMap,
      enableBookingUpdates: json['enableBookingUpdates'] ?? true,
      enablePromotions: json['enablePromotions'] ?? true,
      enableSystemNotifications: json['enableSystemNotifications'] ?? true,
      quietHoursStart: json['quietHoursStart'] != null
          ? TimeOfDay(
        hour: json['quietHoursStart']['hour'],
        minute: json['quietHoursStart']['minute'],
      )
          : null,
      quietHoursEnd: json['quietHoursEnd'] != null
          ? TimeOfDay(
        hour: json['quietHoursEnd']['hour'],
        minute: json['quietHoursEnd']['minute'],
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, bool> typeSettingsJson = {};

    typeSettings.forEach((key, value) {
      typeSettingsJson[key.toString().split('.').last] = value;
    });

    return {
      'enablePush': enablePush,
      'enableEmail': enableEmail,
      'enableSMS': enableSMS,
      'typeSettings': typeSettingsJson,
      'enableBookingUpdates': enableBookingUpdates,
      'enablePromotions': enablePromotions,
      'enableSystemNotifications': enableSystemNotifications,
      'quietHoursStart': quietHoursStart != null
          ? {
        'hour': quietHoursStart!.hour,
        'minute': quietHoursStart!.minute,
      }
          : null,
      'quietHoursEnd': quietHoursEnd != null
          ? {
        'hour': quietHoursEnd!.hour,
        'minute': quietHoursEnd!.minute,
      }
          : null,
    };
  }
}

// Custom TimeOfDay class (since Flutter's TimeOfDay might not be available in all contexts)
class TimeOfDay {
  final int hour;
  final int minute;

  TimeOfDay({
    required this.hour,
    required this.minute,
  });

  @override
  String toString() {
    final hourString = hour.toString().padLeft(2, '0');
    final minuteString = minute.toString().padLeft(2, '0');
    return '$hourString:$minuteString';
  }
}