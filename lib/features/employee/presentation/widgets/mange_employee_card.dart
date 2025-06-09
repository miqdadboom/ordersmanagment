import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_size_box.dart';
import '../screens/edit_employee_screen.dart';
import '../../data/models/EmployeeModel.dart';

class EmployeeCardWidget extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeCardWidget({super.key, required this.employee});

  void _makePhoneCall(BuildContext context, String phoneNumber) async {
    try {
      final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception("Cannot launch dialer");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to make a call: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _sendEmail(BuildContext context, String email) async {
    try {
      final Uri uri = Uri(scheme: 'mailto', path: email);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception("Cannot open email app");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send email: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          if (employee.id != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditEmployee(userId: employee.id!),
              ),
            );
          }
        },
        leading: CircleAvatar(
          backgroundColor: Colors.black12,
          child: Icon(Icons.person, color: AppColors.primary),
        ),
        title: Text(
          employee.name,
          style: AppTextStyles.productCardTitle(context),
        ),
        subtitle: Text(
          employee.role,
          style: AppTextStyles.productCardBrand(context),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (employee.phone.isNotEmpty)
              InkWell(
                onTap: () => _makePhoneCall(context, employee.phone),
                child: Icon(Icons.call, color: AppColors.primary),
              ),
            AppSizedBox.width(context, 0.05),
            if (employee.email.isNotEmpty)
              InkWell(
                onTap: () => _sendEmail(context, employee.email),
                child: Icon(Icons.email, color: AppColors.primary),
              ),
          ],
        ),
      ),
    );
  }
}
