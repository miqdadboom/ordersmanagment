import 'package:flutter/material.dart';
import 'package:ordersmanagment_app/features/products/presentation/widgets/product_card.dart';

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
        return ProductCard(
          image: product['image'],
          name: product['name'],
          brand: product['brand'],
          price: product['price'],
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
