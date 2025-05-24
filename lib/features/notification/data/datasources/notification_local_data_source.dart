import '../../domain/entities/app_notification.dart';

abstract class NotificationLocalDataSource {
  Future<List<AppNotification>> getNotifications();
  Future<AppNotification> getNotificationById(String id);
  Future<void> markAsRead(String notificationId);
  Future<void> cacheNotifications(List<AppNotification> notifications);
}