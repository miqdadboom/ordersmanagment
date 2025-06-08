import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/core/constants/app_size_box.dart';
import 'package:final_tasks_front_end/core/constants/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/user_role_access.dart';
import '../../../../../core/utils/user_access_control.dart';
import '../../../../../core/widgets/bottom_navigation_manager.dart';
import '../../../../confirm_order/presentation/screens/confirm_order.dart';
import '../../../../orders/data/datasources/order_data_source_impl.dart';
import '../../../../orders/domain/repositories/orders_repository.dart';
import '../../../../orders/domain/repositories/orders_repository_impl.dart';
import '../../../../orders/presentation/cubit/orders_cubit.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_product_list.dart';
import '../../../../../core/widgets/bottom_navigation_sales_representative.dart';
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
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    final role = await UserRoleAccess.getUserRole();
    if (!mounted) return;
    setState(() {
      _role = role;
      _loading = false;
    });
  }

  Widget? _buildBottomNavigationBar() {
    if (_role == 'admin') {
      return const BottomNavigationManager();
    } else if (_role == 'salesRepresentative') {
      return const BottomNavigationSalesRepresentative();
    } else {
      return null; // No bottom bar for unauthorized roles
    }
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
        BlocProvider(create: (_) => CartCubit()..loadCartProducts()),
        BlocProvider(
          create: (_) {
            final dataSource = OrderDataSourceImpl();
            final OrderRepository repository = OrderRepositoryImpl(dataSource: dataSource);
            return OrdersCubit(repository);
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
            title: 'Shopping Cart',
          showBackButton: false,
        ),
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<CartCubit, List<Map<String, dynamic>>>(
                builder: (context, state) {
                  double total = context.read<CartCubit>().calculateTotal();
                  return ConfirmOrderBar(
                    totalPrice: total,
                    onConfirm: () {
                      final cartCubit = context.read<CartCubit>();
                      final cartProducts = cartCubit.state;
                      final ordersCubit = context.read<OrdersCubit>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(value: ordersCubit),
                              BlocProvider.value(value: cartCubit),
                            ],
                            child: ConfirmOrder(cartProducts: cartProducts),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
               Divider(height: 1),
              if (_buildBottomNavigationBar() != null)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.075,
                  child: _buildBottomNavigationBar()!,
                ),
            ],
          ),
        ),
        body: const SafeArea(child: CartProductList()),
      ),
    );
  }
}
