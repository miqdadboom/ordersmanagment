import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Widget? customLeading;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.customLeading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: customLeading ??
          (showBackButton
              ? IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppColors.textLight,
            onPressed: () => Navigator.of(context).pop(),
          )
              : null),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textLight,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
