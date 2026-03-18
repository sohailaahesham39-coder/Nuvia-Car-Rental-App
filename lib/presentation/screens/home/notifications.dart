// lib/presentation/screens/notifications/NotificationsScreen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/AppLocalizations.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = false;

  // Dummy data using Notification class - replace with real data from your API
  final List<Notification> _notifications = [
    Notification(
      id: 'notif1',
      userId: 'user1',
      title: 'Booking Confirmed',
      message: 'Your booking for Toyota Fortuner has been confirmed. The car will be ready for pickup on May 15.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.booking,
      isRead: false,
      actionType: 'open_booking',
      actionData: 'booking1',
    ),
    Notification(
      id: 'notif2',
      userId: 'user1',
      title: 'Special Offer',
      message: 'Enjoy 15% off on your next booking! Use code SUMMER15.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.promotion,
      isRead: false,
      actionType: 'open_promotion',
      actionData: 'SUMMER15',
    ),
    Notification(
      id: 'notif3',
      userId: 'user1',
      title: 'New Message',
      message: 'Ahmed Hassan sent you a message regarding your upcoming booking.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.general,
      isRead: true,
      actionType: 'open_chat',
      actionData: 'contact1',
    ),
    Notification(
      id: 'notif4',
      userId: 'user1',
      title: 'Payment Successful',
      message: 'Your payment of EGP 450 for Toyota Fortuner has been successfully processed.',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      type: NotificationType.payment,
      isRead: true,
      actionType: 'open_booking',
      actionData: 'booking1',
    ),
    Notification(
      id: 'notif5',
      userId: 'user1',
      title: 'Upcoming Rental',
      message: 'Your rental for Toyota Fortuner is scheduled for tomorrow. Don\'t forget your ID and driver\'s license!',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      type: NotificationType.reminder,
      isRead: true,
      actionType: 'open_booking',
      actionData: 'booking1',
    ),
    Notification(
      id: 'notif6',
      userId: 'user1',
      title: 'Rate Your Experience',
      message: 'How was your experience with the Mercedes C-Class? Please take a moment to leave a review.',
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      type: NotificationType.general,
      isRead: true,
      actionType: 'open_review',
      actionData: 'booking2',
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        actions: [
          if (_unreadCount > 0)
            TextButton.icon(
              icon: const Icon(Icons.done_all),
              label: Text(l10n.markAllAsRead),
              onPressed: _markAllAsRead,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? _buildEmptyNotifications(context, l10n)
          : RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final notification = _notifications[index];
            return _buildNotificationTile(context, notification);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyNotifications(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noNotifications,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.youHaveNoNotificationsYet,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(BuildContext context, Notification notification) {
    // Get icon based on notification type
    IconData icon;
    Color iconColor;
    switch (notification.type) {
      case NotificationType.booking:
        icon = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case NotificationType.promotion:
        icon = Icons.local_offer;
        iconColor = Colors.purple;
        break;
      case NotificationType.payment:
        icon = Icons.payment;
        iconColor = Colors.teal;
        break;
      case NotificationType.reminder:
        icon = Icons.alarm;
        iconColor = Colors.orange;
        break;
      case NotificationType.general:
        icon = notification.actionType == 'open_chat' ? Icons.chat_bubble : Icons.star;
        iconColor = notification.actionType == 'open_chat' ? Colors.blue : Colors.amber;
        break;
      case NotificationType.system:
        icon = Icons.info;
        iconColor = Colors.blue;
        break;
    }

    return Dismissible(
      key: Key(notification.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _notifications.remove(notification);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification deleted'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                setState(() {
                  _notifications.add(notification);
                  _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
                });
              },
            ),
          ),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: notification.isRead ? Colors.grey.shade600 : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(notification.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: notification.isRead ? null : Colors.blue.shade50.withOpacity(0.3),
        onTap: () => _handleNotificationTap(context, notification),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(timestamp);
    }
  }

  Future<void> _refreshNotifications() async {
    // Implement refresh logic - fetch new notifications from API
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      // Refresh notifications data here
    });
  }

  void _markAllAsRead() {
    setState(() {
      _notifications.forEach((notification) {
        notification = notification.copyWith(isRead: true);
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.allNotificationsMarkedAsRead),
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, Notification notification) {
    // Mark notification as read
    setState(() {
      final index = _notifications.indexOf(notification);
      _notifications[index] = notification.copyWith(isRead: true);
    });

    // Navigate based on notification type and action
    switch (notification.actionType) {
      case 'open_booking':
        if (notification.actionData != null) {
          // Navigator.pushNamed(context, '/booking-details/${notification.actionData}');
          // TODO: Implement navigation to booking details screen
        }
        break;
      case 'open_chat':
        if (notification.actionData != null) {
          // Navigator.pushNamed(context, '/chat', arguments: {'activeContactId': notification.actionData});
          // TODO: Implement navigation to chat screen
        }
        break;
      case 'open_promotion':
        if (notification.actionData != null) {
          // Navigator.pushNamed(context, '/promotions', arguments: {'promoCode': notification.actionData});
          // TODO: Implement navigation to promotions screen
        }
        break;
      case 'open_review':
        if (notification.actionData != null) {
          // Navigator.pushNamed(context, '/write-review/${notification.actionData}');
          // TODO: Implement navigation to review screen
        }
        break;
    }
  }
}

class Notification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? actionType; // 'open_booking', 'open_chat', etc.
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
  booking, // Related to bookings (confirmation, cancellation, etc.)
  payment, // Payment related notifications
  promotion, // Promotions and offers
  system, // System notifications (maintenance, app updates)
  reminder, // Reminders (upcoming booking, return car)
  general, // General notifications
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