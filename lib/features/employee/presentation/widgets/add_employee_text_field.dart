import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class EmployeeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String validatorMessage;
  final Color primaryColor;

  const EmployeeTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.validatorMessage,
    this.primaryColor = AppColors.primary, // قيمة افتراضية
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        validator: (value) =>
        (value == null || value.trim().isEmpty) ? validatorMessage : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: primaryColor),
          hintText: hintText,
          filled: true,
          fillColor: AppColors.background,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: primaryColor.withOpacity(0.4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: Colors.red.shade600, width: 2),
          ),
        ),
      ),
    );
  }
}
