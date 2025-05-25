import 'package:final_tasks_front_end/features/employee/presentation/screens/add_employee_screen.dart';
import 'package:final_tasks_front_end/features/employee/presentation/screens/manage_employee_screen.dart';
import 'package:flutter/material.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';
import '../routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: appRoutes,
    );
  }
}
