import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class EditEmployeeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String validatorMessage;

  const EditEmployeeTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validatorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
            prefixIcon: Icon(icon, color: AppColors.primary),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validatorMessage;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
