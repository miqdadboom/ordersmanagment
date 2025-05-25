import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/home_page/product_card.dart';

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
            final product = products[index];
            return ProductCard(
              image: product['image'] ?? '',
              name: product['name'] ?? '',
              brand: product['brand'] ?? '',
              price: product['price']?.toString() ?? '',
              discount: product['discount'],
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/productView',
                  arguments: {
                    'imageUrl': product['image'] ?? '',
                    'name': product['name'] ?? '',
                    'brand': product['brand'] ?? '',
                    'price':
                        double.tryParse(product['price'].toString()) ??
                        0.0, // ✅
                    'description': product['description'] ?? '',
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}