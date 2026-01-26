import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../services/notification_service.dart';
import '../../services/analytics_service.dart';

/// Notification Center Screen
class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({Key? key}) : super(key: key);

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  final _notificationService = NotificationService();
  final _analytics = AnalyticsService();

  @override
  void initState() {
    super.initState();
    _analytics.trackScreenView('notification_center');
  }

  void _clearAll() {
    setState(() {
      _notificationService.clearAll();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications cleared')),
    );
  }

  void _markAllAsRead() {
    setState(() {
      _notificationService.markAllAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifications = _notificationService.allNotifications;
    final unreadCount = _notificationService.unreadCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications${unreadCount > 0 ? ' ($unreadCount)' : ''}'),
        elevation: 0,
        actions: [
          if (notifications.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.done_all),
              onPressed: _markAllAsRead,
              tooltip: 'Mark all as read',
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAll,
              tooltip: 'Clear all',
            ),
          ],
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'No notifications',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'You\'re all caught up!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            )
          : StreamBuilder<AppNotification>(
              stream: _notificationService.notificationStream,
              builder: (context, snapshot) {
                return ListView.separated(
                  padding: EdgeInsets.all(2.w),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _buildNotificationTile(notification);
                  },
                );
              },
            ),
    );
  }

  Widget _buildNotificationTile(AppNotification notification) {
    final theme = Theme.of(context);
    
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        setState(() {
          _notificationService.deleteNotification(notification.id);
        });
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: notification.getColor(context).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            notification.icon,
            color: notification.getColor(context),
          ),
        ),
        title: Text(
          notification.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.5.h),
            Text(
              notification.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              _formatTimestamp(notification.timestamp),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E7D9A),
                  shape: BoxShape.circle,
                ),
              ),
        onTap: () {
          if (!notification.isRead) {
            setState(() {
              _notificationService.markAsRead(notification.id);
            });
          }
          if (notification.onAction != null) {
            notification.onAction!();
          }
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
