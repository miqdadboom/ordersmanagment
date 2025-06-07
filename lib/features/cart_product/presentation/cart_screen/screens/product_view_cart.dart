import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/core/constants/app_size_box.dart';
import 'package:final_tasks_front_end/core/constants/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/user_role_access.dart';
import '../../../../../core/utils/user_access_control.dart';
import '../../../../products/presentation/cubit/product_quantity_cubit.dart';
import '../../../../products/presentation/widgets/product_view/product_description.dart';
import '../../../../products/presentation/widgets/product_view/product_text_details.dart';
import '../../../data/models/product_cart_entity.dart';

class ProductViewCart extends StatefulWidget {
  final ProductCartEntity product;

  const ProductViewCart({super.key, required this.product});

  @override
  State<ProductViewCart> createState() => _ProductViewCartState();
}

class _ProductViewCartState extends State<ProductViewCart> {
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!UserAccessControl.ProductView(_role!)) {
      return const Scaffold(
        body: Center(child: Text('You are not authorized to view this page.')),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => ProductQuantityCubit(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Product View'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenWidth * 0.3,
                        left: screenWidth * 0.04,
                        right: screenWidth * 0.02,
                      ),
                      child: BlocBuilder<ProductQuantityCubit, int>(
                        builder: (context, quantity) {
                          return TextDescription(
                            name: widget.product.name,
                            brand: widget.product.brand,
                            price: widget.product.price,
                            quantity: quantity,

                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.01),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                      ),
                      child: Image.network(
                        widget.product.imageUrl,
                        height: screenWidth * 0.85,
                        width: screenWidth * 0.55,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                child: DescriptionProduct(description: widget.product.description),
              ),
              AppSizedBox.height(context, 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
