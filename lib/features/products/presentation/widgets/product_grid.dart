import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/features/homepage/domain/entities/products_entity.dart';
import '../../../homepage/presentation/widgets/home_page/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final bool enableSorting;

  const ProductGrid({
    super.key,
    required this.products,
    this.enableSorting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (enableSorting) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Sort by:', style: TextStyle(fontWeight: FontWeight.bold)),
              // Add sorting dropdown here if needed
            ],
          ),
          const SizedBox(height: 8),
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final productMap = products[index];

            final productEntity = ProductEntity(
              imageUrl: productMap['image'] ?? '',
              title: productMap['name'] ?? '',
              brand: productMap['brand'] ?? '',
              price: double.tryParse(productMap['price'].toString()) ?? 0.0,
              description: productMap['description'] ?? '',
              quantity: productMap['quantity'] ?? 1,
            );

            return ProductCardHome(
              product: productEntity,
              discount: productMap['discount'],
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/productView',
                  arguments: {
                    'imageUrl': productEntity.imageUrl,
                    'name': productEntity.title,
                    'brand': productEntity.brand,
                    'price': productEntity.price,
                    'description': productEntity.description,
                    'documentId': productMap['documentId'], // ✅ تم تمريره
                  },
                );
              },
              onAddToCart: () async {
                final cartItem = {
                  'title': productEntity.title,
                  'brand': productEntity.brand,
                  'price': productEntity.price,
                  'quantity': 1,
                  'imageUrl': productEntity.imageUrl,
                  'description': productEntity.description,
                };

                final userId = FirebaseAuth.instance.currentUser!.uid;
                final cartRef = FirebaseFirestore.instance
                    .collection('cart')
                    .doc(userId);

                final doc = await cartRef.get();
                List<dynamic> items = [];
                if (doc.exists) {
                  items = doc.data()?['products'] ?? [];
                }

                final existingIndex = items.indexWhere(
                  (item) => item['title'] == productEntity.title,
                );
                if (existingIndex == -1) {
                  items.add(cartItem);
                } else {
                  items[existingIndex]['quantity'] += 1;
                }

                await cartRef.set({'products': items});

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added to cart',
                      style: TextStyle(color: AppColors.snakeColor),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class PaginatedProductList extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final ScrollController scrollController;
  final bool isLoadingMore;

  const PaginatedProductList({
    Key? key,
    required this.products,
    required this.scrollController,
    required this.isLoadingMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProductGrid(products: products, enableSorting: false),
        if (isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
