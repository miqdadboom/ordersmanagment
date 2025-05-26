import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/user_access_control.dart';
import '../../../cart_product/domain/entities/quantity_model.dart';
import '../../../cart_product/presentation/cart_screen/cubit/cart_cubit.dart';
import '../../../cart_product/presentation/cart_screen/widgets/quantity_controller.dart';
import '../cubit/product_quantity_cubit.dart';
import '../widgets/product_view/add_cart_bar.dart';
import '../widgets/product_view/product_description.dart';
import '../widgets/product_view/product_text_details.dart';

class ProductView extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String brand;
  final double price;
  final String description;

  const ProductView({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.brand,
    required this.price,
    required this.description,
  });

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  String? _role;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!UserAccessControl.ProductView(_role!)) {
      return const Scaffold(
        body: Center(child: Text('You are not authorized to view this page.')),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProductQuantityCubit()),
        BlocProvider(create: (_) => CartCubit()..loadCartProducts()),
      ],
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
                          final quantityController = TextEditingController(text: quantity.toString());

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              const SizedBox(height: 10),
                              Text(widget.brand, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              const SizedBox(height: 20),
                              Text(
                                '\$${widget.price.toStringAsFixed(2)}',
                                style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                              ),
                              const SizedBox(height: 50),

                              QuantityController(
                                model: QuantityModel(quantity: quantity, price: widget.price),
                                quantityController: quantityController,
                                onIncrement: cubit.increment,
                                onDecrement: cubit.decrement,
                                onQuantityChanged: (oldQty, newQty, _) {
                                  cubit.setQuantity(newQty);
                                },
                              ),
                            ],
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
        bottomNavigationBar: BlocBuilder<ProductQuantityCubit, int>(
          builder: (context, quantity) {
            return AddCart(
                quantity: quantity,
                unitPrice: widget.price,
              onAdd: () async {
                  final product = {
                    'imageUrl': widget.imageUrl,
                    'title': widget.name,
                    'brand': widget.brand,
                    'price': widget.price,
                    'description': widget.description,
                    'quantity': quantity,
                  };
                  await context.read<CartCubit>().addProductToCart(product);
                  if(context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                          content: Text(
                            "Product added to cart",
                            style: TextStyle(color: AppColors.snakeColor),
                          ),
                      ),
                    );
                  }
              }
            );
          },
        ),
      ),
    );
  }
}
