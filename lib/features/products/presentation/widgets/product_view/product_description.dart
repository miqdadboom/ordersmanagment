import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';

class DescriptionProduct extends StatelessWidget {
  final String description;

  const DescriptionProduct({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, 
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 18, color: AppColors.textDescription),
          ),
        ],
      ),
    );
  }
}
