import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class QuantityController extends StatelessWidget {
  final int quantity;
  final double price;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final TextEditingController quantityController;
  final Function(int oldQuantity, int newQuantity, double price) onQuantityChanged;

  const QuantityController({
    super.key,
    required this.quantity,
    required this.price,
    required this.onDecrement,
    required this.onIncrement,
    required this.quantityController,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth * 0.10;

    return Container(
      height: buttonSize,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(buttonSize / 2),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onIncrement,
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(buttonSize / 2),
                  bottomLeft: Radius.circular(buttonSize / 2),
                ),
              ),
              child: Icon(Icons.add, size: buttonSize * 0.5, color: AppColors.quantityIcons),
            ),
          ),
          Container(
            width: buttonSize,
            height: buttonSize,
            alignment: Alignment.center,
            color: AppColors.background,
            child: TextField(
              controller: quantityController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: buttonSize * 0.45,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(top: 4, bottom: 0),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null && parsed > 0 && parsed != quantity) {
                  onQuantityChanged(quantity, parsed, price);
                }
              },
            ),
          ),
          GestureDetector(
            onTap: onDecrement,
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(buttonSize / 2),
                  bottomRight: Radius.circular(buttonSize / 2),
                ),
              ),
              child: Icon(
                Icons.remove,
                size: buttonSize * 0.5,
                color: quantity > 1 ? AppColors.quantityIcons : AppColors.quantityIcons,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
