import '../repositories/notification_repository.dart';

class MarkNotificationAsRead {
  final NotificationRepository repository;

  MarkNotificationAsRead(this.repository);

  Future<void> call(String id) async {
    await repository.markAsRead(id);
  }
}