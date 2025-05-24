import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/user_access_control.dart';
import '../cubit/product_quantity_cubit.dart';
import '../widgets/add_cart_bar.dart';
import '../widgets/product_description.dart';
import '../widgets/product_text_details.dart';

class ProductView extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String brand;
  final double price;

  const ProductView({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.brand,
    required this.price,
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!UserAccessControl.ProductView(_role!)) {
      return const Scaffold(body: Center(child: Text('You are not authorized to view this page.')));
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => ProductQuantityCubit(),
      child: Scaffold(
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
                            starting: "Starting",
                            price: widget.price,
                            promotional: "Promotional text",
                            quantity: quantity,
                            quantityController: TextEditingController(text: quantity.toString()),
                            onIncrement: cubit.increment,
                            onDecrement: cubit.decrement,
                            onQuantityChanged: (oldQty, newQty, price) {
                              cubit.setQuantity(newQty);
                            },
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
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: DescriptionProduct(),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder<ProductQuantityCubit, int>(
          builder: (context, quantity) {
            return AddCart(quantity: quantity, unitPrice: widget.price);
          },
        ),
      ),
    );
  }
}
