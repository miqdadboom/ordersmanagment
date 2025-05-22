import 'package:flutter/material.dart';
import 'package:ordersmanagment_app/constants/app_colors.dart';
import 'package:ordersmanagment_app/features/products/domain/entities/category.dart';
import 'package:ordersmanagment_app/features/products/presentation/screens/filter_products.dart';
import 'package:ordersmanagment_app/features/products/presentation/widgets/home_page/product_search_delegate.dart';
import 'package:ordersmanagment_app/features/products/presentation/widgets/home_page/product_card.dart';
import 'package:ordersmanagment_app/features/products/presentation/widgets/home_page/promo_banner.dart';
import 'package:ordersmanagment_app/features/products/presentation/widgets/home_page/sidebar.dart';
import 'package:ordersmanagment_app/features/products/presentation/widgets/home_page/tap_bar.dart';
import 'package:ordersmanagment_app/features/products/presentation/widgets/home_page/category.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final List<Map<String, dynamic>> products = List.generate(10, (index) {
    return {
      'name': 'Product ${index + 1}',
      'brand': 'Brand ${index + 1}',
      'price': '\$${(index + 5) * 2}.99',
      'discount': index % 3 == 0 ? '10% OFF' : null,
      'image':
          'https://images.pexels.com/photos/${27085501 + index}/pexels-photo-${27085501 + index}.jpeg',
    };
  });

  final List<Category> categories = List.generate(
    6,
    (index) => Category(
      'https://images.pexels.com/photos/${27085501 + index}/pexels-photo-${27085501 + index}.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      'Category ${index + 1}',
    ),
  );

  void _showCategoryPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('All Categories'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(category.imageUrl),
                  ),
                  title: Text(category.name),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FilterProductsScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(products),
              );
            },
          ),
        ],
      ),
      drawer: const AppSidebar(),
      bottomNavigationBar: const BottomNavigationSalesRepresentative(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PromoBanner(),
            CategorySection(
              categories: categories,
              onCategoryTap: (index) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FilterProductsScreen(),
                  ),
                );
              },
              onViewAllTap: () => _showCategoryPopup(context),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSectionHeader('Products', 'View All', () {
                    debugPrint('View All Products clicked');
                  }),
                  const SizedBox(height: 16),
                  _buildProductsGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String actionText,
    VoidCallback onAction,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildProductsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          image: product['image'],
          name: product['name'],
          brand: product['brand'],
          price: product['price'],
          discount: product['discount'],
          onTap: () => debugPrint('Product ${index + 1} tapped'),
        );
      },
    );
  }
}
