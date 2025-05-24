import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/app_notification.dart';
import '../models/notification_model.dart';
import 'notification_local_data_source.dart';

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  static const String _cachedNotificationsKey = 'CACHED_NOTIFICATIONS';
  static const String _cachedNotificationPrefix = 'CACHED_NOTIFICATION_';
  final bool _useMockData;

  NotificationLocalDataSourceImpl({bool useMockData = false})
      : _useMockData = useMockData;

  @override
  Future<List<AppNotification>> getNotifications() async {
    if (_useMockData) {
      return _getMockNotifications();
    }

    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getStringList(_cachedNotificationsKey);
    if (cachedData != null && cachedData.isNotEmpty) {
      return cachedData
          .map((json) => NotificationModel.fromJson(jsonDecode(json)).toEntity())
          .toList();
    }
    return _getMockNotifications();
  }

  List<AppNotification> _getMockNotifications() {
    return [
      AppNotification(
        id: '1',
        title: 'Welcome to the App!',
        description: 'Thank you for installing our application.',
        senderName: 'System',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      AppNotification(
        id: '2',
        title: 'New Feature Available',
        description: 'Check out our latest update with new features!',
        senderName: 'Support Team',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      AppNotification(
        id: '3',
        title: 'Reminder: Complete Your Profile',
        description: 'Please complete your profile to access all features.',
        senderName: 'System',
        timestamp: DateTime.now(),
        isRead: true,
      ),
    ];
  }

  @override
  Future<AppNotification> getNotificationById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationJson = prefs.getString('$_cachedNotificationPrefix$id');
    if (notificationJson != null) {
      return NotificationModel.fromJson(jsonDecode(notificationJson)).toEntity();
    }
    throw Exception('Notification not found in cache');
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final prefs = await SharedPreferences.getInstance();

    // Update in the notifications list
    final notifications = await getNotifications();
    final updatedNotifications = notifications.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();

    await cacheNotifications(updatedNotifications);

    // Update individual cached notification
    final notificationJson = prefs.getString('$_cachedNotificationPrefix$notificationId');
    if (notificationJson != null) {
      final notification = NotificationModel.fromJson(jsonDecode(notificationJson));
      final updatedNotification = notification.copyWith(isRead: true);
      await prefs.setString(
        '$_cachedNotificationPrefix$notificationId',
        jsonEncode(updatedNotification.toJson()),
      );
    }
  }

  @override
  Future<void> cacheNotifications(List<AppNotification> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = notifications
        .map((notification) => jsonEncode(
      NotificationModel.fromEntity(notification).toJson(),
    ))
        .toList();
    await prefs.setStringList(_cachedNotificationsKey, notificationsJson);

    // Cache each notification individually for faster lookup
    for (final notification in notifications) {
      await prefs.setString(
        '$_cachedNotificationPrefix${notification.id}',
        jsonEncode(NotificationModel.fromEntity(notification).toJson()),
      );
    }
  }

  Future<void> clearAllCachedNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachedNotificationsKey);

    // Remove all individual cached notifications
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_cachedNotificationPrefix)) {
        await prefs.remove(key);
      }
    }
  }
}