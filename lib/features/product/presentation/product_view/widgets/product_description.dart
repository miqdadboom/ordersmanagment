import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class DescriptionProduct extends StatelessWidget {
  const DescriptionProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        Text(
          "Description",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
          style: TextStyle(
            fontSize: 18,
            color: AppColors.textDescription,
          ),
        ),
      ],
    );
  }
}
