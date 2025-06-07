import 'package:final_tasks_front_end/features/cart_product/presentation/cart_screen/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/place.dart';
import '../widgets/confirm_order_actions.dart';
import '../widgets/confirm_order_fields.dart';
import '../widgets/confirm_order_header.dart';
import '../../domain/use_cases/confirm_order_cubit.dart';
import '../../../orders/presentation/screens/list_of_orders_screen.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';

class ConfirmOrder extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> cartProducts;

  const ConfirmOrder({super.key, required this.cartProducts});

  @override
  ConsumerState<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends ConsumerState<ConfirmOrder> {
  final ConfirmOrderCubit _controller = ConfirmOrderCubit();
  final _formKey = GlobalKey<FormState>();

  void _submitOrder(BuildContext context) {

    if(!_formKey.currentState!.validate()) return;

    final order = _controller.createOrder(widget.cartProducts);
    if (order == null) {

      return;
    }

    final cubit = context.read<OrdersCubit>();
    cubit.addOrder(order);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const ListOfOrdersScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: screenHeight * 0.1),
        child: Center(
          child: Container(
            height: screenHeight * 0.85,
            width: screenWidth * 0.9,
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.startConfirmOrder, AppColors.endConfirmOrder],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConfirmOrderHeader(screenWidth: screenWidth),
                ConfirmOrderFields(
                  formKey: _formKey,
                  nameController: _controller.nameController,
                  notesController: _controller.notesController,
                  onLocationSelected: (PlaceLocation location) {
                    setState(() {
                      _controller.selectedLocation = location;
                    });
                  },
                ),

                const Spacer(),
                ConfirmOrderActions(
                  onSend: () async {
                    await _controller.sendOrderToFirebase(
                      context: context,
                      cartProducts: widget.cartProducts,
                    );
                    _submitOrder(context);

                    final cartCubit = context.read<CartCubit>();
                    cartCubit.clearCart();

                    _controller.nameController.clear();
                    _controller.notesController.clear();
                    setState(() {
                      _controller.selectedLocation = null;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}