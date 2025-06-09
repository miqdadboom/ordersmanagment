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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: screenHeight * 0.15, // ~150
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(screenWidth * 0.03), // ~12
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child:
            image != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  child: Image.file(
                    image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: screenWidth * 0.12, // ~50
                      color: AppColors.primary,
                    ),
                    SizedBox(height: screenHeight * 0.012), // ~10
                    Text(
                      "Tap to add image",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: screenWidth * 0.04, // ~16
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
