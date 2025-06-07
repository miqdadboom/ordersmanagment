import 'package:final_tasks_front_end/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../../../../../core/constants/app_colors.dart';

class ConfirmOrderActions extends StatelessWidget {
  final VoidCallback onSend;

  const ConfirmOrderActions({super.key, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          context: context,
          label: "Not Yet",
          onPressed: () {
            Navigator.pushNamed(context, '/cartScreen');
          },
        ),
        _buildActionButton(
          context: context,
          label: "Send Order",
          onPressed: onSend,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [BoxShadow(color: AppColors.boxShadow, blurRadius: 4)],
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(icon, color: AppColors.icon)
            : const SizedBox.shrink(),
        label: Text(
          label,
          style:  AppTextStyles.actionButtonText(context),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.06,
            vertical: MediaQuery.of(context).size.height * 0.015,
          ),
        ),
      ),
    );
  }
}
