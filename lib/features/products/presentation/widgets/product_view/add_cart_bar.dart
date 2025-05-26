import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AddCart extends StatelessWidget {
  final int quantity;
  final double unitPrice;
  final VoidCallback onAdd;

  const AddCart({
    super.key,
    required this.quantity,
    required this.unitPrice,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    double totalPrice = quantity * unitPrice;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      height: screenWidth * 0.22,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.background,
            AppColors.cardBackground,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "Total Price: \$${totalPrice.toStringAsFixed(1)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.textDark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child:  Text(
              'Add To Cart',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark
              ),
            ),
          ),
        ],
      ),
    );
  }
}
