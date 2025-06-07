import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cart_cubit.dart';
import 'cart_product_item.dart';

class CartProductList extends StatelessWidget {
  const CartProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, List<Map<String, dynamic>>>(
      builder: (context, products) {
        if (products.isEmpty) {
          return const Center(child: Text('Your cart is empty'));
        }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return CartProductItem(index: index, product: product);
      },
    );
      },
    );
  }
}
