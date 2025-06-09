import 'package:final_tasks_front_end/features/chat_bot/presentation/screens/home_chat_bot_screen.dart';
import 'package:final_tasks_front_end/features/employee/presentation/screens/add_employee_screen.dart';
import 'package:final_tasks_front_end/features/employee/presentation/screens/manage_employee_screen.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/screens/home_page.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../routes/app_routes.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/screens/management/promo_banner_management_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        ...appRoutes,
        '/PromoBannerManagementScreen':
            (context) => const PromoBannerManagementScreen(),
      },
    );
  }
}
