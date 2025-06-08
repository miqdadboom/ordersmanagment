import 'package:flutter/material.dart';
import 'auth_routes.dart';
import 'order_routes.dart';
import 'product_routes.dart';
import 'employee_routes.dart';
import 'chat_routes.dart';
import 'notification_routes.dart';

final Map<String, WidgetBuilder> appRoutes = {
  ...authRoutes,
  ...orderRoutes,
  ...productRoutes,
  ...employeeRoutes,
  ...chatRoutes,
  ...notificationRoutes,
};
