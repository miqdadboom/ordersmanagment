import 'package:final_tasks_front_end/features/cart_product/presentation/cart_screen/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cart_cubit.dart';

class CartProductItem extends StatelessWidget {
  final int index;
  final Map<String, dynamic> product;

  const CartProductItem({
    super.key,
    required this.index,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    final controller = TextEditingController(
      text: product['quantity'].toString(),
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/productView',
          arguments: {
            'imageUrl': product['imageUrl'],
            'name': product['title'],
            'brand': product['subtitle'],
            'price': product['price'],
            'description': product['description'],
          },
        );
      },
      child: ProductCard(
        imageUrl: product['imageUrl'],
        title: product['title'],
        subtitle: product['subtitle'],
        price: product['price'],
        quantity: product['quantity'],
        quantityController: controller,
        onTotalChange: cubit.updateTotal,
        onRemove: () => cubit.removeProduct(index),
        onQuantityChanged:
            (oldQty, newQty, price) =>
                cubit.updateQuantity(index, oldQty, newQty),
      ),
    );
  }
}
