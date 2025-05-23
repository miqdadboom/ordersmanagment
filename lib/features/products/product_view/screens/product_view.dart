import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/product_quantity_cubit.dart';
import '../widgets/add_cart_bar.dart';
import '../widgets/product_description.dart';
import '../widgets/product_sizes.dart';
import '../widgets/product_text_details.dart';

class ProductView extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                            name: name,
                            brand: brand,
                            starting: "Starting",
                            price: price,
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
                        imageUrl,
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
              SizedBox(height: 25,),
              const SizeProduct(),
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder<ProductQuantityCubit, int>(
          builder: (context, quantity) {
            return AddCart(quantity: quantity, unitPrice: price);
          },
        ),
      ),
    );
  }
}
