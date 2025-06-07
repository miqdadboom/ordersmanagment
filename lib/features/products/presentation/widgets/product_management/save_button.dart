import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.15, // ~50 if width ≈ 375
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.03), // ~12
        ),
      ),
      child: Text(
        "Save Product",
        style: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.045, // ~17
        ),
      ),
    );
  }
}
