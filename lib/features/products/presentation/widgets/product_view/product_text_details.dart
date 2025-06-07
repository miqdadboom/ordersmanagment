import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_text_styles.dart';
import '../../../../cart_product/presentation/cart_screen/widgets/quantity_controller.dart';

class TextDescription extends StatelessWidget {
  final String name;
  final String brand;
  final double price;
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final TextEditingController? quantityController;
  final Function(int oldQty, int newQty, double price)? onQuantityChanged;

  const TextDescription({
    super.key,
    required this.name,
    required this.brand,
    required this.price,
    required this.quantity,
    this.onIncrement,
    this.onDecrement,
    this.quantityController,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: AppTextStyles.productCardTitle(context)),
        const SizedBox(height: 10),
        Text(brand, style: AppTextStyles.productCardBrand(context)),
        const SizedBox(height: 35),
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: AppTextStyles.productCardBrand(context).copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
