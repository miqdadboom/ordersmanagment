import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class ConfirmOrderBar extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onConfirm;
  const ConfirmOrderBar({super.key, required this.totalPrice, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenWidth * 0.20,
      padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary, // Pale Robin Egg Blue
            AppColors.cardBackground, // Persian Green
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total price",
                  style: TextStyle(color: AppColors.textDark, fontSize: screenWidth * 0.045,fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${totalPrice.toStringAsFixed(1)}",
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.boxShadow,
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: TextButton(
              onPressed: onConfirm,
              style: TextButton.styleFrom(
                padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: screenWidth * 0.03),
              ),
              child:  Text(
                "Confirm order",
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}