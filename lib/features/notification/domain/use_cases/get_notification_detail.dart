import '../repositories/notification_repository.dart';
import '../entities/app_notification.dart';

class GetNotificationDetail {
  final NotificationRepository repository;

  GetNotificationDetail(this.repository);

  Future<AppNotification> call(String id) async {
    return await repository.getNotificationById(id);
  }
}