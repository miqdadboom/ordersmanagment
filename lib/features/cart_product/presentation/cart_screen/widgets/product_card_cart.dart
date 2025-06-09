import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/core/constants/app_size_box.dart';
import 'package:final_tasks_front_end/features/homepage/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/quantity_model.dart';
import '../cubit/cart_cubit.dart';
import 'quantity_controller.dart';

class ProductCardCart extends StatefulWidget {
  final ProductEntity product;
  final Function(double) onTotalChange;
  final VoidCallback onRemove;
  final TextEditingController quantityController;
  final Function(int oldQuantity, int newQuantity, double price)
  onQuantityChanged;

  const ProductCardCart({
    super.key,
    required this.product,
    required this.onTotalChange,
    required this.onRemove,
    required this.quantityController,
    required this.onQuantityChanged,
  });

  @override
  State<ProductCardCart> createState() => _ProductCardCartState();
}

class _ProductCardCartState extends State<ProductCardCart> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.product.quantity;
  }

  void increment() {
    final oldQuantity = quantity;
    final newQuantity = oldQuantity + 1;

    setState(() {
      quantity = newQuantity;
      widget.quantityController.text = newQuantity.toString();
    });

    final cubit = context.read<CartCubit>();
    final index = cubit.state.indexWhere(
      (p) => p['title'] == widget.product.title,
    );
    if (index != -1) {
      cubit.updateQuantity(index, newQuantity);
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
      final index = cubit.state.indexWhere(
        (p) => p['title'] == widget.product.title,
      );
      if (index != -1) {
        cubit.updateQuantity(index, newQuantity);
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Product Deletion'),
            content: const Text(
              'Are you sure you want to remove this product from the cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.dialogCancelButton(context),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onRemove();
                },
                child: Text(
                  'Delete',
                  style: AppTextStyles.dialogDeleteButton(context),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
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
                  widget.product.imageUrl,
                  width: screenWidth * 0.25,
                  height: screenWidth * 0.25,
                  fit: BoxFit.cover,
                ),
              ),
              AppSizedBox.width(context, 0.015),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.04,
                    left: MediaQuery.of(context).size.width * 0.015,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.title,
                        style: AppTextStyles.productCardTitle(context),
                      ),
                      AppSizedBox.height(context, 0.005),

                      Text(
                        widget.product.brand,
                        style: AppTextStyles.productCardBrand(context),
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
              child: Icon(Icons.close, color: AppColors.icon),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.01,
            right: MediaQuery.of(context).size.width * 0.02,
            child: QuantityController(
              model: QuantityModel(
                quantity: quantity,
                price: widget.product.price,
              ),
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
