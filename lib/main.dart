import 'package:flutter/material.dart';
import 'package:ordersmanagment_app/features/auth/presentation/screens/login_screen.dart';
import 'package:ordersmanagment_app/features/employee/presentation/screens/add_employee_screen.dart';
import 'package:ordersmanagment_app/features/employee/presentation/screens/manage_employee_screen.dart';
import 'package:ordersmanagment_app/features/employee/presentation/screens/edit_employee_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sales App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/manage': (context) => ManageEmployee(),
        '/add': (context) => const AddEmployee(),
        '/edit': (context) => const EditEmployee(),
      },
    );
  }
}
