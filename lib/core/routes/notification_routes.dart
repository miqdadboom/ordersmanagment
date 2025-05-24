import 'package:flutter/material.dart';
import '../../../features/notification/presentation/screens/notification_detail_screen.dart';
import '../../../features/notification/presentation/screens/notification_list_screen.dart';

final Map<String, WidgetBuilder> notificationRoutes = {
  '/notificationDetail': (context) {
    final notificationId = ModalRoute.of(context)!.settings.arguments as String;
    return NotificationDetailScreen(notificationId: notificationId);
  },
  '/notificationList': (context) => const NotificationListScreen(),
};
