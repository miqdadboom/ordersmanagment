import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/utils/user_access_control.dart';
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

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? _role;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final role = doc['role'];

    if (!mounted) return;
    setState(() {
      _role = role;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!UserAccessControl.CartScreen(_role!)) {
      return const Scaffold(
        body: Center(child: Text("You are not authorized to access this page.")),
      );
    }

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
          backgroundColor: AppColors.primary,
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
