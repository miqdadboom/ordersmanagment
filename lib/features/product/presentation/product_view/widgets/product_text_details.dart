import 'package:flutter/material.dart';
import '../../../../../core/widgets/common_text.dart';
import '../../cart_screen/widgets/quantity_controller.dart';

class TextDescription extends StatelessWidget {
  final String name;
  final String brand;
  final String starting;
  final double price;
  final String promotional;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final TextEditingController quantityController;
  final Function(int oldQty, int newQty, double price) onQuantityChanged;

  const TextDescription({
    super.key,
    required this.name,
    required this.brand,
    required this.starting,
    required this.price,
    required this.promotional,
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
        CommonText(text: starting, size: 18, isBold: true),
        const SizedBox(height: 10),
        CommonText(text: '\$${price.toStringAsFixed(2)}', size: 18, isBold: true),
        const SizedBox(height: 10),
        CommonText(text: promotional, size: 18, isBold: true),
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
