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
