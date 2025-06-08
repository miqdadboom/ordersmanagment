import '../../domain/repositories/notification_repository.dart';
import '../../domain/entities/app_notification.dart';
import '../datasources/notification_remote_data_source.dart';
import '../datasources/notification_local_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<AppNotification>> getNotifications() async {
    try {
      final remoteNotifications = await remoteDataSource.fetchNotifications();
      await localDataSource.cacheNotifications(remoteNotifications);
      return remoteNotifications;
    } catch (_) {
      return await localDataSource.getNotifications();
    }
  }

  @override
  Future<AppNotification> getNotificationById(String id) async {
    try {
      final remoteNotification = await remoteDataSource.fetchNotificationById(id);
      return remoteNotification;
    } catch (_) {
      return await localDataSource.getNotificationById(id);
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await remoteDataSource.markNotificationAsRead(notificationId);
    } finally {
      await localDataSource.markAsRead(notificationId);
    }
  }


}