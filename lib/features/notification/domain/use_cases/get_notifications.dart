import '../repositories/notification_repository.dart';
import '../entities/app_notification.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<List<AppNotification>> call({
    required String role,
    required String userId,
  }) async {
    return await repository.getNotifications(role: role, userId: userId);
  }
}
