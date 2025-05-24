import 'package:flutter/material.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';

final Map<String, WidgetBuilder> authRoutes = {
  '/login': (context) => LoginScreen(),
};
