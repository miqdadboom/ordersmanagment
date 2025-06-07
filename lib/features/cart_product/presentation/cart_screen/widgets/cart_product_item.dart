import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cart_cubit.dart';
import 'product_card_cart.dart';
import 'package:final_tasks_front_end/features/products/domain/entities/products_entity.dart';

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

    final productEntity = ProductEntity(
      imageUrl: product['imageUrl'] ?? '',
      title: product['title'] ?? '',
      brand: product['brand'] ?? '',
      price: product['price'] is double
          ? product['price']
          : double.tryParse(product['price'].toString()) ?? 0.0,
      description: product['description'] ?? '',
      quantity: product['quantity'] ?? 1,
    );

    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/productViewCart',
            arguments: {
              'imageUrl': product['imageUrl'],
              'name': product['title'],
              'brand': product['subtitle'],
              'price': product['price'],
              'description': product['description'] ?? '',
            },
          );
        },

         child:  ProductCardCart(
            product: productEntity,
            quantityController: controller,
            onRemove: () => cubit.removeProduct(index),
            onTotalChange: (_) {},
            onQuantityChanged: (oldQty, newQty, price) {
              cubit.updateQuantity(index, newQty);
            },
    ),
    );
    }
  }

