import 'package:final_tasks_front_end/core/constants/app_size_box.dart';
import 'package:final_tasks_front_end/core/widgets/bottom_navigation_manager.dart';
import 'package:final_tasks_front_end/core/widgets/bottom_navigation_sales_representative.dart';
import 'package:final_tasks_front_end/core/widgets/bottom_navigation_warehouse_manager.dart';
import 'package:final_tasks_front_end/features/homepage/data/firebase/category_repository.dart';
import 'package:final_tasks_front_end/features/homepage/domain/entities/category.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_tasks_front_end/features/homepage/data/firebase/product_repository.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/screens/filter_products_screen.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/home_page/category.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/home_page/product_search_delegate.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/home_page/promo_banner.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/home_page/sidebar.dart';
import '../../../products/presentation/widgets/product_grid.dart';
import 'package:final_tasks_front_end/core/constants/custom_app_bar.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/product_grid.dart'
    show PaginatedProductList;

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
  String? errorMessageProducts;
  String? errorMessageCategories;

  // pagination
  final ScrollController _scrollController = ScrollController();
  DocumentSnapshot? lastDocument;
  bool isLoadingMore = false;
  bool hasMore = true;
  final int pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      fetchMoreProducts();
    }
  }

  Future<void> _loadInitialData() async {
    await _getUserRole();
    await getCategories();
    await getProducts(initial: true);
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
        errorMessageCategories = null;
      });
    } catch (e) {
      setState(() {
        errorMessageCategories =
            'Failed to load categories. Please try again later.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessageCategories!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> getProducts({bool initial = false}) async {
    try {
      if (initial) {
        setState(() {
          isLoading = true;
          products = [];
          lastDocument = null;
          hasMore = true;
        });
      }
      final fetchedProducts = await widget.productRepository
          .getProductsPaginated(limit: pageSize, startAfter: lastDocument);
      setState(() {
        if (initial) {
          products = fetchedProducts;
        } else {
          products.addAll(fetchedProducts);
        }
        isLoading = false;
        errorMessageProducts = null;
        if (fetchedProducts.isNotEmpty) {
          lastDocument = fetchedProducts.last['__documentSnapshot'];
        }
        if (fetchedProducts.length < pageSize) {
          hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessageProducts =
            'Failed to load products. Please try again later.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessageProducts!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchMoreProducts() async {
    if (isLoadingMore || !hasMore || isLoading) return;
    setState(() {
      isLoadingMore = true;
    });
    final fetchedProducts = await widget.productRepository.getProductsPaginated(
      limit: pageSize,
      startAfter: lastDocument,
    );
    setState(() {
      products.addAll(fetchedProducts);
      isLoadingMore = false;
      if (fetchedProducts.isNotEmpty) {
        lastDocument = fetchedProducts.last['__documentSnapshot'];
      }
      if (fetchedProducts.length < pageSize) {
        hasMore = false;
      }
    });
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
      case 'salesRepresentative':
        return const BottomNavigationSalesRepresentative();
      case 'warehouseEmployee':
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

    if (errorMessageProducts != null || errorMessageCategories != null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Home Page',
          showBackButton: false,
          customLeading: Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
          ),
        ),
        body: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Column(
              key: ValueKey(errorMessageProducts ?? errorMessageCategories),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off, color: Colors.red, size: 48),
                AppSizedBox.height(context, 0.02),
                const Text(
                  'Failed to load data. Please check your connection or try again later.',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                AppSizedBox.height(context, 0.03),
                ElevatedButton.icon(
                  onPressed:
                      isLoading
                          ? null
                          : () async {
                            setState(() {
                              isLoading = true;
                            });
                            await _loadInitialData();
                          },
                  icon:
                      isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Icon(Icons.refresh),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Retry'),
                      if (isLoading) ...[
                        AppSizedBox.width(context, 0.02),
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: const AppSidebar(),
        bottomNavigationBar: _getBottomNavigation(),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home Page',
        showBackButton: false,
        customLeading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
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
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await getCategories();
                await getProducts(initial: true);
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const PromoBannerSlider(),
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
                          AppSizedBox.height(context, 0.02),
                          PaginatedProductList(
                            products: products,
                            scrollController: _scrollController,
                            isLoadingMore: isLoadingMore,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
