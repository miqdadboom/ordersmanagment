import 'package:flutter/cupertino.dart';

import '../../domain/entities/app_notification.dart';
import 'notification_remote_data_source.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  // Store mock notifications in memory
  final List<AppNotification> _mockNotifications = [
    AppNotification(
      id: '101',
      title: 'New Message from Server',
      description: 'This is a mock notification from the server',
      senderName: 'Server',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
    ),
    AppNotification(
      id: '102',
      title: 'Server Update Available',
      description: ' New features are waiting for you, New features are waiting for you, New features are waiting for you, New features are waiting for you',
      senderName: 'System',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: true,
    ),
  ];

  @override
  Future<List<AppNotification>> fetchNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockNotifications;
  }

  @override
  Future<AppNotification> fetchNotificationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Find the notification with matching ID
    return _mockNotifications.firstWhere(
          (notification) => notification.id == id,
      orElse: () => throw Exception('Notification not found'),
    );
  }

  @override
  Future<void> markNotificationAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In a real app, you would update the server here
    debugPrint('Notification $id marked as read on server (mock)');
  }
}