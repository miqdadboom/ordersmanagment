import 'package:flutter/material.dart';
import '../../../features/employee/presentation/screens/manage_employee_screen.dart';
import '../../../features/employee/presentation/screens/add_employee_screen.dart';
import '../../../features/employee/presentation/screens/edit_employee_screen.dart';

final Map<String, WidgetBuilder> employeeRoutes = {
  '/manage': (context) => ManageEmployee(),
  '/add': (context) => const AddEmployee(),
  '/edit': (context) => const EditEmployee(userId: ''),
};
