import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SizeProduct extends StatelessWidget {
  const SizeProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primary,
          child: Text("S", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),),
        ),
        const SizedBox(width: 10),
        const Icon(Icons.chevron_right),
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primary,
          child: Text("M", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),),
        ),
        const SizedBox(width: 10),
        const Icon(Icons.chevron_right),
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primary,
          child: Text("L", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),),
        ),
      ],
    );
  }
}