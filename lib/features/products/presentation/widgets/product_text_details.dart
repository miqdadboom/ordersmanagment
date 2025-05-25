import 'package:flutter/material.dart';
import '../../../../../core/widgets/common_text.dart';
import '../../../cart_product/presentation/cart_screen/widgets/quantity_controller.dart';

class TextDescription extends StatelessWidget {
  final String name;
  final String brand;
  final double price;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final TextEditingController quantityController;
  final Function(int oldQty, int newQty, double price) onQuantityChanged;

  const TextDescription({
    super.key,
    required this.name,
    required this.brand,
    required this.price,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.quantityController,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(text: name, size: 24, isBold: true),
        const SizedBox(height: 10),
        CommonText(text: brand, size: 18, isBold: true),
        const SizedBox(height: 35),
        CommonText(
          text: '\$${price.toStringAsFixed(2)}',
          size: 18,
          isBold: true,
        ),
        const SizedBox(height: 30),
        QuantityController(
          quantity: quantity,
          price: price,
          quantityController: quantityController,
          onDecrement: onDecrement,
          onIncrement: onIncrement,
          onQuantityChanged: onQuantityChanged,
        ),
      ],
    );
  }
}
