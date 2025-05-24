import 'package:bloc/bloc.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/use_cases/get_notifications.dart';
import '../../domain/use_cases/get_notification_detail.dart' as detail;
import '../../domain/use_cases/mark_notification_as_read.dart' as mark;

abstract class NotificationState {
  final List<AppNotification> notifications;

  const NotificationState({this.notifications = const []});
}

class NotificationInitial extends NotificationState {
  const NotificationInitial() : super();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading({List<AppNotification> notifications = const []})
      : super(notifications: notifications);
}

class NotificationLoaded extends NotificationState {
  const NotificationLoaded(List<AppNotification> notifications)
      : super(notifications: notifications);
}

class NotificationDetailState extends NotificationState {
  final AppNotification notification;

  const NotificationDetailState(this.notification, {List<AppNotification> notifications = const []})
      : super(notifications: notifications);
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message, {List<AppNotification> notifications = const []})
      : super(notifications: notifications);
}


class NotificationCubit extends Cubit<NotificationState> {
  final GetNotifications getNotifications;
  final detail.GetNotificationDetail getNotificationDetail;
  final mark.MarkNotificationAsRead markNotificationAsRead;

  NotificationCubit({
    required this.getNotifications,
    required this.getNotificationDetail,
    required this.markNotificationAsRead,
  }) : super(NotificationInitial());

  Future<void> loadNotifications() async {
    emit(NotificationLoading());
    try {
      final notifications = await getNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
  Future<void> loadNotificationDetail(String id) async {
    emit(NotificationLoading());
    try {
      final notification = await getNotificationDetail(id);
      emit(NotificationDetailState(notification));
    } catch (e) {
      emit(NotificationError('Failed to load notification details'));
      // Re-emit the previous state so the list remains visible
      if (state is NotificationLoaded) {
        emit(state as NotificationLoaded);
      }
    }
  }

  Future<void> markNotificationRead(String id) async {
    try {
      await markNotificationAsRead(id);
      if (state is NotificationLoaded) {
        final currentState = state as NotificationLoaded;
        final updatedNotifications = currentState.notifications.map((n) {
          if (n.id == id) {
            return AppNotification(
              id: n.id,
              title: n.title,
              description: n.description,
              senderName: n.senderName,
              timestamp: n.timestamp,
              isRead: true,
            );
          }
          return n;
        }).toList();
        emit(NotificationLoaded(updatedNotifications));
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}