import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

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
        leading: CircleAvatar(
          backgroundColor: Colors.black12,
          child: Icon(Icons.person, color: AppColors.primary),
        ),
        title: Text(employee["name"] ?? ""),
        subtitle: Text(employee["job"] ?? ""),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.call, color: AppColors.primary),
            const SizedBox(width: 25),
            Icon(Icons.email, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
