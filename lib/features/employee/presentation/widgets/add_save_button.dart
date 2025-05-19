import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({
    super.key,
    required this.onPressed, required Color color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(200),
        ),
      ),
      child: const Text(
        'Save',
        style: TextStyle(fontSize: 18, color: AppColors.textLight),
      ),
    );
  }
}
