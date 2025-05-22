import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cart_cubit.dart';
import 'cart_product_item.dart';

class CartProductList extends StatelessWidget {
  const CartProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, dynamic>(
        builder: (context, state) {
      final cubit = context.read<CartCubit>();
      final products = cubit.products;

      if (products.isEmpty) {
        return const Center(child: Text('Your cart is empty.'));
      }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      physics: const BouncingScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = cubit.products[index];
        return CartProductItem(index: index, product: product);
      },
    );
      },
    );
  }
}
