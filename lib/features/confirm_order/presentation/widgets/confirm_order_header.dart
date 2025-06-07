import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';

class ConfirmOrderHeader extends StatelessWidget {
  final double screenWidth;
  const ConfirmOrderHeader({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Text(
      "You are Confirm this order ?",
      style: AppTextStyles.confirmOrderHeader(context),
      textAlign: TextAlign.center,
    );
  }
}
