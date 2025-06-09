import 'package:final_tasks_front_end/features/products/presentation/screens/product_view.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/home_page/product_card.dart';
import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/features/homepage/domain/entities/product_entity.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final results =
        allProducts.where((product) {
          final name = product['name'].toString().toLowerCase();
          return name.contains(query.trim().toLowerCase());
        }).toList();

    if (results.isEmpty) {
      return const Center(child: Text('No products found.'));
    }

    return GridView.builder(
      padding: EdgeInsets.all(screenWidth * 0.04), // ~16
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: screenHeight * 0.015, // ~12
        crossAxisSpacing: screenWidth * 0.03, // ~12
        childAspectRatio: screenWidth / (screenHeight / 1.4),
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];

        final entity = ProductEntity(
          id: product['documentId'] ?? '',
          name: product['name'] ?? '',
          imageUrl: product['image'] ?? '',
          price: double.tryParse(product['price'].toString()) ?? 0.0,
          description: product['description'] ?? '',
          categoryId: product['categoryId'] ?? '',
          title: product['name'] ?? '',
          brand: product['brand'] ?? '',
          quantity: product['quantity'] ?? 1,
        );

        return ProductCardHome(
          product: entity,
          discount: product['discount'],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ProductView(
                      imageUrl: product['image'] ?? '',
                      name: product['name'] ?? '',
                      brand: product['brand'] ?? '',
                      price:
                          double.tryParse(product['price'].toString()) ?? 0.0,
                      description: product['description'] ?? '',
                      documentId: product['documentId'] ?? '',
                    ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final suggestions =
        allProducts.where((product) {
          final name = product['name'].toString().toLowerCase();
          return name.contains(query.trim().toLowerCase());
        }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          title: Text(
            product['name'],
            style: TextStyle(fontSize: screenWidth * 0.045), // ~18
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            product['brand'],
            style: TextStyle(fontSize: screenWidth * 0.035), // ~14
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            query = product['name'];
            showResults(context);
          },
        );
      },
    );
  }
}
