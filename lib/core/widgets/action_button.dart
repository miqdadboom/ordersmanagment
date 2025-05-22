
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [BoxShadow(color: AppColors.boxShadow, blurRadius: 4)],
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, color: AppColors.icon) : const SizedBox(),
        label: Text(
          label,
          style:  TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
