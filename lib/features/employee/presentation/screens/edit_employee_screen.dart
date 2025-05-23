import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/edit_employee_form.dart';

class EditEmployee extends StatelessWidget {
  final String userId;

  const EditEmployee({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: EditEmployeeForm(userId: userId),
      ),
    );
  }
}
