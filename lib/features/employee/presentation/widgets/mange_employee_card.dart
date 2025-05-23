import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../screens/edit_employee_screen.dart';

class EmployeeCardWidget extends StatelessWidget {
  final Map<String, String> employee;

  const EmployeeCardWidget({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, '/edit');

        },
        leading: CircleAvatar(
          backgroundColor: Colors.black12,
          child: Icon(Icons.person, color: AppColors.primary),
        ),
        title: Text(
          employee["name"] ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          employee["job"] ?? "",
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {

              },
              child: Icon(Icons.call, color: AppColors.primary),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {

              },
              child: Icon(Icons.email, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
