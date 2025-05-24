import '../../domain/entities/app_notification.dart';

abstract class NotificationRemoteDataSource {
  Future<List<AppNotification>> fetchNotifications();
  Future<AppNotification> fetchNotificationById(String id);
  Future<void> markNotificationAsRead(String id);
}