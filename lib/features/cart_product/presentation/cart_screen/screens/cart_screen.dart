import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_product_list.dart';
import '../../../../../core/widgets/bottom_navigation_sales_representative.dart';
import '../../../../../core/widgets/common_text.dart';
import '../widgets/confirm_order_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit()..initializeProducts(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: CommonText(
            text: "Shopping Cart",
            isBold: true,
            size: MediaQuery.of(context).size.width * 0.06,
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<CartCubit, double>(
                builder: (context, total) => ConfirmOrderBar(totalPrice: total),
              ),
              const Divider(height: 1),
              SizedBox(height: 60, child: BottomNavigationSalesRepresentative()),
            ],
          ),
        ),
        body: const SafeArea(child: CartProductList()),
      ),
    );
  }
}
