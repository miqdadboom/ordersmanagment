import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/product_quantity_cubit.dart';
import '../widgets/add_cart_bar.dart';
import '../widgets/product_description.dart';
import '../widgets/product_text_details.dart';

class ProductView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => ProductQuantityCubit(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
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
                              final cubit =
                                  context.read<ProductQuantityCubit>();
                              return TextDescription(
                                name: name,
                                brand: brand,
                                price: price,
                                quantity: quantity,
                                quantityController: TextEditingController(
                                  text: quantity.toString(),
                                ),
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
                          child:
                              imageUrl.trim().isNotEmpty
                                  ? Image.network(
                                    imageUrl,
                                    height: screenWidth * 0.85,
                                    width: screenWidth * 0.55,
                                    fit: BoxFit.cover,
                                  )
                                  : Container(
                                    height: screenWidth * 0.85,
                                    width: screenWidth * 0.55,
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                      color: Colors.black54,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DescriptionProduct(description: description),
                  ),
                  const SizedBox(height: 25),
                ],
              ),

              // ✅ زر الرجوع في الزاوية الشمال العليا
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 28,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
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
