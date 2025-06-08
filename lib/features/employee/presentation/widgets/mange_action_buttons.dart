import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_size_box.dart'; // ✅ إضافة AppSizedBox

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onAddPressed;
  final ValueChanged<String> onSortSelected;

  const ActionButtonsWidget({
    super.key,
    required this.onAddPressed,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = AppTextStyles.button(context);

    return Row(
      children: [
        // زر الإضافة
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onAddPressed,
            icon: const Icon(Icons.person_add, color: Colors.white),
            label: Text("Add Employee", style: buttonTextStyle),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        AppSizedBox.width(context, 0.025), // بدل SizedBox(width: 10)

        // زر PopupMenuButton للفرز
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: PopupMenuButton<String>(
              onSelected: onSortSelected,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'name_asc',
                  child: Text('Name A-Z', style: AppTextStyles.bodySuggestion(context)),
                ),
                PopupMenuItem(
                  value: 'name_desc',
                  child: Text('Name Z-A', style: AppTextStyles.bodySuggestion(context)),
                ),
                PopupMenuItem(
                  value: 'job_asc',
                  child: Text('Job A-Z', style: AppTextStyles.bodySuggestion(context)),
                ),
                PopupMenuItem(
                  value: 'job_desc',
                  child: Text('Job Z-A', style: AppTextStyles.bodySuggestion(context)),
                ),
                PopupMenuItem(
                  value: 'reset',
                  child: Text('Reset to Original', style: AppTextStyles.bodySuggestion(context)),
                ),
              ],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sort", style: buttonTextStyle),
                  AppSizedBox.width(context, 0.015), // بدل SizedBox(width: 6)
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
