import 'package:flutter/material.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/employee/presentation/screens/add_employee_screen.dart';
import 'features/employee/presentation/screens/edit_employee_screen.dart';
import 'features/employee/presentation/screens/manage_employee_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sales App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  AddEmployee(),
    );
  }
}
