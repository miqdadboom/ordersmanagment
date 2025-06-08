import '../../domain/entities/app_notification.dart';

abstract class NotificationRemoteDataSource {
  Future<List<AppNotification>> fetchNotifications();
  Future<AppNotification> fetchNotificationById(String id);
  Future<void> markNotificationAsRead(String id);
  Future<void> sendNotification({
    required String title,
    required String body,
    required bool isRead,
  });

}

