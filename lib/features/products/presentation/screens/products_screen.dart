import 'package:final_tasks_front_end/core/widgets/bottom_navigation_manager.dart';
import 'package:final_tasks_front_end/core/widgets/bottom_navigation_sales_representative.dart';
import 'package:final_tasks_front_end/core/widgets/bottom_navigation_warehouse_manager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/features/products/data/firebase/category_repository.dart';
import 'package:final_tasks_front_end/features/products/data/firebase/product_repository.dart';
import 'package:final_tasks_front_end/features/products/domain/entities/category.dart';
import 'package:final_tasks_front_end/features/products/presentation/screens/filter_products_screen.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/home_page/category.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/home_page/product_search_delegate.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/home_page/promo_banner.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/home_page/sidebar.dart';
import '../widgets/product_grid.dart';

class ProductsScreen extends StatefulWidget {
  final ProductRepository productRepository;
  final CategoryRepository categoryRepository;

  ProductsScreen({
    super.key,
    ProductRepository? productRepository,
    CategoryRepository? categoryRepository,
  }) : productRepository = productRepository ?? ProductRepository(),
       categoryRepository = categoryRepository ?? CategoryRepository();

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Map<String, dynamic>> products = [];
  List<Category> categories = [];
  bool isLoading = true;
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _getUserRole();
    await getCategories();
    await getProducts();
  }

  Future<void> _getUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() {
      _role = doc.data()?['role'];
    });
  }

  Future<void> getCategories() async {
    try {
      final fetchedCategories = await widget.categoryRepository.getCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  Future<void> getProducts() async {
    try {
      final fetchedProducts = await widget.productRepository.getProducts();
      setState(() {
        products = fetchedProducts;
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
                            (_) => FilterProductsScreen(
                              categoryName: category.name,
                              productRepository: widget.productRepository,
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

  Widget _getBottomNavigation() {
    switch (_role) {
      case 'admin':
        return const BottomNavigationManager();
      case 'sales representative':
        return const BottomNavigationSalesRepresentative();
      case 'warehouse employee':
        return const BottomNavigationWarehouseManager();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (_role == null || isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
      bottomNavigationBar: _getBottomNavigation(),
      body: RefreshIndicator(
        onRefresh: () async {
          await getCategories();
          await getProducts();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                          (_) => FilterProductsScreen(
                            categoryName: categoryName,
                            productRepository: widget.productRepository,
                          ),
                    ),
                  );
                },
                onViewAllTap: () => _showCategoryPopup(context),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  children: [
                    _buildSectionHeader(screenWidth),
                    SizedBox(height: screenHeight * 0.02),
                    ProductGrid(products: products, enableSorting: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Products',
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
