import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class BuildTextField extends StatelessWidget {
  final String hint;
  final int maxLines;
  final TextEditingController? controller;
  const BuildTextField({
    super.key,
    required this.hint,
    this.maxLines = 1,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: AppColors.background,
      ),
    );
  }
}
