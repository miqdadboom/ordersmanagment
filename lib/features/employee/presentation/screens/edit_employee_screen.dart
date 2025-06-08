import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/edit_employee_form.dart';
import '../widgets/add_employee_appbar.dart'; // نفس AppBar المستخدم في الإضافة

class EditEmployee extends StatelessWidget {
  final String userId;

  const EditEmployee({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const EmployeeAppBar(
        primaryColor: AppColors.primary,
        title: 'Edit Employee',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: EditEmployeeForm(userId: userId),
      ),
    );
  }
}
