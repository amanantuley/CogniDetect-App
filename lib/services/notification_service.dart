import 'dart:async';
import 'package:flutter/material.dart';

/// Advanced notification service for in-app notifications and reminders
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<AppNotification> _notifications = [];
  final StreamController<AppNotification> _notificationController =
      StreamController<AppNotification>.broadcast();

  Stream<AppNotification> get notificationStream => _notificationController.stream;
  List<AppNotification> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();
  List<AppNotification> get allNotifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// Show a notification
  void showNotification({
    required String title,
    required String message,
    NotificationType type = NotificationType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? autoHideDuration,
  }) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      timestamp: DateTime.now(),
      actionLabel: actionLabel,
      onAction: onAction,
    );

    _notifications.insert(0, notification);
    _notificationController.add(notification);

    if (autoHideDuration != null) {
      Future.delayed(autoHideDuration, () {
        markAsRead(notification.id);
      });
    }
  }

  /// Schedule a reminder
  void scheduleReminder({
    required String title,
    required String message,
    required DateTime scheduledTime,
    Map<String, dynamic>? metadata,
  }) {
    final timeUntil = scheduledTime.difference(DateTime.now());
    
    if (timeUntil.isNegative) return;

    Future.delayed(timeUntil, () {
      showNotification(
        title: title,
        message: message,
        type: NotificationType.reminder,
      );
    });
  }

  /// Show success notification
  void showSuccess(String message, {String? title}) {
    showNotification(
      title: title ?? 'Success',
      message: message,
      type: NotificationType.success,
      autoHideDuration: const Duration(seconds: 3),
    );
  }

  /// Show error notification
  void showError(String message, {String? title}) {
    showNotification(
      title: title ?? 'Error',
      message: message,
      type: NotificationType.error,
      autoHideDuration: const Duration(seconds: 5),
    );
  }

  /// Show warning notification
  void showWarning(String message, {String? title}) {
    showNotification(
      title: title ?? 'Warning',
      message: message,
      type: NotificationType.warning,
      autoHideDuration: const Duration(seconds: 4),
    );
  }

  /// Show info notification
  void showInfo(String message, {String? title}) {
    showNotification(
      title: title ?? 'Info',
      message: message,
      type: NotificationType.info,
      autoHideDuration: const Duration(seconds: 3),
    );
  }

  /// Mark notification as read
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  /// Mark all as read
  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  /// Delete notification
  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
  }

  /// Clear all notifications
  void clearAll() {
    _notifications.clear();
  }

  /// Clear old notifications (older than specified duration)
  void clearOldNotifications(Duration age) {
    final cutoffTime = DateTime.now().subtract(age);
    _notifications.removeWhere((n) => n.timestamp.isBefore(cutoffTime));
  }

  void dispose() {
    _notificationController.close();
  }
}

/// Notification types
enum NotificationType {
  success,
  error,
  warning,
  info,
  reminder,
  achievement,
}

/// Notification model
class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? actionLabel;
  final VoidCallback? onAction;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionLabel,
    this.onAction,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionLabel: actionLabel ?? this.actionLabel,
      onAction: onAction ?? this.onAction,
    );
  }

  IconData get icon {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.reminder:
        return Icons.notifications;
      case NotificationType.achievement:
        return Icons.stars;
      default:
        return Icons.info;
    }
  }

  Color getColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (type) {
      case NotificationType.success:
        return const Color(0xFF2A9D8F);
      case NotificationType.error:
        return const Color(0xFFE76F51);
      case NotificationType.warning:
        return const Color(0xFFE9C46A);
      case NotificationType.achievement:
        return const Color(0xFFF4A261);
      default:
        return theme.colorScheme.primary;
    }
  }
}
