import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AddCart extends StatelessWidget {
  final int quantity;
  final double unitPrice;
  const AddCart({super.key,required this.quantity,required this.unitPrice});

  @override
  Widget build(BuildContext context) {
    double totalPrice = quantity * unitPrice;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenWidth * 0.22,
      padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.background,
            AppColors.cardBackground,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Total Price:",
            style:
            TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: AppColors.textDark,
            ),
          ),
          Text(
            "\$${totalPrice.toStringAsFixed(1)}",
            style:
            TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
