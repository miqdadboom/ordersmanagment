import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/user_role_access.dart';
import '../../../../../core/utils/user_access_control.dart';
import '../../../../products/presentation/cubit/product_quantity_cubit.dart';
import '../../../../products/presentation/widgets/product_view/product_description.dart';
import '../../../../products/presentation/widgets/product_view/product_text_details.dart';

class ProductViewCart extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String brand;
  final double price;
  final String description;

  const ProductViewCart({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.brand,
    required this.price,
    required this.description,
  });

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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text(
            'Product View',
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 0,
        ),
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
                          final cubit = context.read<ProductQuantityCubit>();
                          return TextDescription(
                            name: widget.name,
                            brand: widget.brand,
                            price: widget.price,
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
                        widget.imageUrl,
                        height: screenWidth * 0.85,
                        width: screenWidth * 0.55,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DescriptionProduct(description: widget.description),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
