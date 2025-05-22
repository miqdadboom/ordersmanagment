import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cart_cubit.dart';
import 'quantity_controller.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final double price;
  final int quantity;
  final Function(double) onTotalChange;
  final VoidCallback onRemove;
  final TextEditingController quantityController;
  final Function(int oldQuantity, int newQuantity, double price) onQuantityChanged;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.onTotalChange,
    required this.onRemove,
    required this.quantityController,
    required this.onQuantityChanged,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.quantity;
  }

  void increment() {
    final oldQuantity = quantity;
    final newQuantity = oldQuantity + 1;

    setState(() {
      quantity = newQuantity;
      widget.quantityController.text = newQuantity.toString();
    });

    final cubit = context.read<CartCubit>();
    final index = cubit.products.indexWhere((p) => p['title'] == widget.title);
    if (index != -1) {
      cubit.updateQuantity(index, oldQuantity, newQuantity);
    }

  }

  void decrement() {
    if (quantity > 1) {
      final oldQuantity = quantity;
      final newQuantity = oldQuantity - 1;

      setState(() {
        quantity = newQuantity;
        widget.quantityController.text = newQuantity.toString();
      });

      final cubit = context.read<CartCubit>();
      final index = cubit.products.indexWhere((p) => p['title'] == widget.title);
      if (index != -1) {
        cubit.updateQuantity(index, oldQuantity, newQuantity);
      }

    }
  }


  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Product Deletion'),
        content: const Text('Are you sure you want to remove this product from the cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.textDark)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onRemove();
            },
            child: Text('Delete', style: TextStyle(color: AppColors.iconDelete)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.background,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.imageUrl,
                  width: screenWidth * 0.25,
                  height: screenWidth * 0.25,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30, left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _showDeleteConfirmation(context),
              child:  Icon(Icons.close, color: AppColors.icon),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: QuantityController(
              quantity: quantity,
              price: widget.price,
              quantityController: widget.quantityController,
              onDecrement: decrement,
              onIncrement: increment,
              onQuantityChanged: (oldQty, newQty, price) {
                setState(() {
                  quantity = newQty;
                });
                widget.onQuantityChanged(oldQty, newQty, price);
              },
            ),
          ),
        ],
      ),
    );
  }
}
