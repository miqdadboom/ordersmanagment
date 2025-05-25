import 'dart:io';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;

  const ImagePickerWidget({
    super.key,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child:
            image != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(image!, fit: BoxFit.cover),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.image, size: 50, color: AppColors.primary),
                    SizedBox(height: 10),
                    Text(
                      "Tap to add image",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
      ),
    );
  }
}
