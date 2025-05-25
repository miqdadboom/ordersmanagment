import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/filter_home_page/brand_and_sort_dropdowns.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/filter_home_page/makeup_type_dialog.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/filter_home_page/makeup_type_filter.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/filter_home_page/search_bar.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/product_grid.dart';

class FilterProductsScreen extends StatefulWidget {
  final String categoryName;

  const FilterProductsScreen({super.key, this.categoryName = 'All'});

  @override
  State<FilterProductsScreen> createState() => _FilterProductsScreenState();
}

class _FilterProductsScreenState extends State<FilterProductsScreen> {
  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> products = [];
  Set<String> selectedTypes = {'all'};
  String selectedBrand = 'All Brands';
  String sortBy = 'Default';
  bool isLoading = true;

  List<String> makeupTypes = ['all'];
  List<String> availableBrands = ['All Brands'];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchProductsByBrand();
  }

  Future<void> fetchProductsByBrand() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .where('mainType', isEqualTo: widget.categoryName)
              .get();

      final fetched = snapshot.docs.map((doc) => doc.data()).toList();

      setState(() {
        allProducts = fetched;
        extractTypesFromProducts();
        extractBrandsFromProducts();
        applyFilters();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching products: $e');
      setState(() => isLoading = false);
    }
  }

  void extractTypesFromProducts() {
    final types =
        allProducts.map((p) => p['subType']?.toString() ?? '').toSet();
    types.removeWhere((type) => type.isEmpty);
    makeupTypes = ['all', ...types];
  }

  void extractBrandsFromProducts() {
    final brands = allProducts.map((p) => p['brand']?.toString() ?? '').toSet();
    brands.removeWhere((b) => b.isEmpty);
    availableBrands = ['All Brands', ...brands];
  }

  void applyFilters() {
    List<Map<String, dynamic>> filtered = [...allProducts];

    if (!selectedTypes.contains('all')) {
      filtered =
          filtered.where((product) {
            final type = (product['subType'] ?? '').toLowerCase();
            return selectedTypes.any((t) => t.toLowerCase() == type);
          }).toList();
    }

    if (selectedBrand != 'All Brands') {
      filtered =
          filtered.where((product) {
            return (product['brand'] ?? '').toLowerCase() ==
                selectedBrand.toLowerCase();
          }).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered =
          filtered.where((product) {
            final name = (product['name'] ?? '').toString().toLowerCase();
            final brand = (product['brand'] ?? '').toString().toLowerCase();
            return name.contains(searchQuery.toLowerCase()) ||
                brand.contains(searchQuery.toLowerCase());
          }).toList();
    }

    if (sortBy == 'Price: Low to High') {
      filtered.sort((a, b) => (a['price'] ?? 0.0).compareTo(b['price'] ?? 0.0));
    } else if (sortBy == 'Price: High to Low') {
      filtered.sort((a, b) => (b['price'] ?? 0.0).compareTo(a['price'] ?? 0.0));
    }

    setState(() {
      products = filtered;
    });
  }

  void toggleType(String type) {
    setState(() {
      if (type == 'all') {
        selectedTypes = {'all'};
      } else {
        selectedTypes.remove('all');
        if (selectedTypes.contains(type)) {
          selectedTypes.remove(type);
        } else {
          selectedTypes.add(type);
        }
        if (selectedTypes.isEmpty) selectedTypes = {'all'};
      }
      applyFilters();
    });
  }

  void showAllTypesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => MakeupTypeDialog(
            makeupTypes: makeupTypes,
            selectedTypes: selectedTypes,
            onTypeToggle: toggleType,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(color: AppColors.textLight),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SearchBarWidget(
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                  applyFilters();
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            MakeupTypeFilter(
                              makeupTypes: makeupTypes,
                              selectedTypes: selectedTypes,
                              onTypeSelected: toggleType,
                              onViewAllPressed:
                                  () => showAllTypesDialog(context),
                            ),
                            const SizedBox(height: 16),
                            BrandAndSortDropdowns(
                              availableBrands: availableBrands,
                              selectedBrand: selectedBrand,
                              sortBy: sortBy,
                              onBrandChanged: (value) {
                                setState(() {
                                  selectedBrand = value!;
                                  applyFilters();
                                });
                              },
                              onSortChanged: (value) {
                                setState(() {
                                  sortBy = value!;
                                  applyFilters();
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Found ${products.length} Results',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ProductGrid(
                              products: products,
                              enableSorting: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
