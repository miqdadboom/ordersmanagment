import 'package:final_tasks_front_end/features/products/presentation/widgets/home_page/product_card.dart';
import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/features/products/domain/entities/products_entity.dart';

class ProductSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> allProducts;

  ProductSearchDelegate(this.allProducts);

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = '';
        }
      },
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) {
    final results =
        allProducts.where((product) {
          final name = product['name'].toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();

    if (results.isEmpty) {
      return const Center(child: Text('No products found.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];

        final entity = ProductEntity(
          imageUrl: product['image'] ?? '',
          title: product['name'] ?? '',
          brand: product['brand'] ?? '',
          price: double.tryParse(product['price'].toString()) ?? 0.0,
          description: product['description'] ?? '',
          quantity: product['quantity'] ?? 1,
        );

        return ProductCardHome(
          product: entity,
          discount: product['discount'],
          onTap: () => debugPrint('${product['name']} tapped'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        allProducts.where((product) {
          final name = product['name'].toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          title: Text(product['name']),
          subtitle: Text(product['brand']),
          onTap: () {
            query = product['name'];
            showResults(context);
          },
        );
      },
    );
  }
}
