import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../confirm_order/presentation/screens/confirm_order.dart';
import '../../../../orders/data/datasources/order_data_source_impl.dart';
import '../../../../orders/data/repositories/orders_repository_impl.dart';
import '../../../../orders/domain/repositories/orders_repository.dart';
import '../../../../orders/domain/repositories/orders_repository_impl.dart';
import '../../../../orders/presentation/cubit/orders_cubit.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_product_list.dart';
import '../../../../../core/widgets/bottom_navigation_sales_representative.dart';
import '../../../../../core/widgets/common_text.dart';
import '../widgets/confirm_order_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CartCubit()..initializeProducts()),
        BlocProvider(
          create: (_) {
            final dataSource = OrderDataSourceImpl();
            final OrderRepository repository = OrderRepositoryImpl(dataSource: dataSource);
            return OrdersCubit(repository);
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          automaticallyImplyLeading: false,
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
                builder: (context, total) => ConfirmOrderBar(
                  totalPrice: total,
                  onConfirm: () {
                    final cartProducts = context.read<CartCubit>().products;
                    final ordersCubit = context.read<OrdersCubit>();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: ordersCubit,
                          child: ConfirmOrder(cartProducts: cartProducts),
                        ),
                      ),
                    );
                  },
                ),
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
