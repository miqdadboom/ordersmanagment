import 'package:final_tasks_front_end/core/widgets/bottom_navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/core/widgets/bottom_navigation_sales_representative.dart';
import 'package:final_tasks_front_end/features/products/domain/entities/category.dart';
import 'package:final_tasks_front_end/features/products/presentation/screens/filter_products.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/home_page/category.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/home_page/product_search_delegate.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/home_page/promo_banner.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/home_page/sidebar.dart';

import '../widgets/product_grid.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Map<String, dynamic>> products = [];
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCategories();
    getProducts();
  }

  Future<void> getCategories() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      setState(() {
        categories =
            snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList();
      });
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  Future<void> getProducts() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('products').get();
      setState(() {
        products =
            snapshot.docs.map((doc) {
              final data = doc.data();
              data['documentId'] = doc.id; // ✅ أضف الـ ID هنا
              return data;
            }).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching products: $e');
      setState(() => isLoading = false);
    }
  }

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
                        builder:
                            (context) => FilterProductsScreen(
                              categoryName: category.name,
                            ),
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () async {
                  await getCategories();
                  await getProducts();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(), // ✅ ضروري
                  child: Column(
                    children: [
                      const PromoBanner(),
                      CategorySection(
                        categories: categories,
                        onCategoryTap: (index) {
                          final categoryName = categories[index].name;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => FilterProductsScreen(
                                    categoryName: categoryName,
                                  ),
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
                            ProductGrid(
                              products: products,
                              enableSorting: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
}
