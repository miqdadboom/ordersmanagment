// lib/domain/repositories/notification_repository.dart
import '../entities/app_notification.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getNotifications();
  Future<AppNotification> getNotificationById(String id);
  Future<void> markAsRead(String notificationId);

}