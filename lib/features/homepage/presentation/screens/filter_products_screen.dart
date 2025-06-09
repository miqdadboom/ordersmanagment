import 'package:final_tasks_front_end/core/constants/app_size_box.dart';
import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/features/homepage/data/firebase/product_repository.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/filter_home_page/brand_and_sort_dropdowns.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/filter_home_page/makeup_type_dialog.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/filter_home_page/makeup_type_filter.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/filter_home_page/search_bar.dart';
import '../../../products/presentation/widgets/product_grid.dart'
    show PaginatedProductList;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_tasks_front_end/core/constants/custom_app_bar.dart';

class FilterProductsScreen extends StatefulWidget {
  final String categoryName;
  final ProductRepository productRepository;

  FilterProductsScreen({
    super.key,
    this.categoryName = 'All',
    ProductRepository? productRepository,
  }) : productRepository = productRepository ?? ProductRepository();

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
  String? errorMessage;

  List<String> makeupTypes = ['all'];
  List<String> availableBrands = ['All Brands'];
  String searchQuery = '';

  final ScrollController _scrollController = ScrollController();
  DocumentSnapshot? lastDocument;
  bool isLoadingMore = false;
  bool hasMore = true;
  final int pageSize = 20;

  @override
  void initState() {
    super.initState();
    fetchProductsByBrand(initial: true);
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

  Future<void> fetchProductsByBrand({bool initial = false}) async {
    try {
      if (initial) {
        setState(() {
          isLoading = true;
          products = [];
          lastDocument = null;
          hasMore = true;
          errorMessage = null;
        });
      }
      final fetched = await widget.productRepository.getProductsByCategory(
        widget.categoryName,
      );
      final paginated = fetched.take(pageSize).toList();
      setState(() {
        allProducts = fetched;
        products = paginated;
        extractTypesFromProducts();
        extractBrandsFromProducts();
        applyFilters();
        isLoading = false;
        if (paginated.isNotEmpty) {
          lastDocument =
              null;
        }
        if (paginated.length < pageSize) {
          hasMore = false;
        }
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load products. Please try again later.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage!), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> fetchMoreProducts() async {
    if (isLoadingMore || !hasMore || isLoading) return;
    setState(() {
      isLoadingMore = true;
    });
    final nextProducts =
        allProducts.skip(products.length).take(pageSize).toList();
    setState(() {
      products.addAll(nextProducts);
      isLoadingMore = false;
      if (nextProducts.length < pageSize) {
        hasMore = false;
      }
    });
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

    if (sortBy == 'PriceLow') {
      filtered.sort((a, b) => (a['price'] ?? 0.0).compareTo(b['price'] ?? 0.0));
    } else if (sortBy == 'PriceHigh') {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (errorMessage != null) {
      return Scaffold(
        appBar: CustomAppBar(title: widget.categoryName, showBackButton: true),
        body: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Column(
              key: ValueKey(errorMessage),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off, color: Colors.red, size: 48),
                AppSizedBox.height(
                  context,
                  16 / MediaQuery.of(context).size.height,
                ),
                const Text(
                  'Failed to load data. Please check your connection or try again later.',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                AppSizedBox.height(
                  context,
                  24 / MediaQuery.of(context).size.height,
                ),
                ElevatedButton.icon(
                  onPressed:
                      isLoading
                          ? null
                          : () async {
                            setState(() {
                              isLoading = true;
                            });
                            await fetchProductsByBrand(initial: true);
                          },
                  icon:
                      isLoading
                          ? SizedBox(
                            width:
                                MediaQuery.of(context).size.width *
                                (20 / MediaQuery.of(context).size.width),
                            height:
                                MediaQuery.of(context).size.height *
                                (20 / MediaQuery.of(context).size.height),
                            child: const CircularProgressIndicator(
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
                        AppSizedBox.width(
                          context,
                          8 / MediaQuery.of(context).size.width,
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width *
                              (16 / MediaQuery.of(context).size.width),
                          height:
                              MediaQuery.of(context).size.height *
                              (16 / MediaQuery.of(context).size.height),
                          child: const CircularProgressIndicator(
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
      );
    }

    return Scaffold(
      appBar: CustomAppBar(title: widget.categoryName, showBackButton: true),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
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
                          AppSizedBox.height(context, 0.025),
                          MakeupTypeFilter(
                            makeupTypes: makeupTypes,
                            selectedTypes: selectedTypes,
                            onTypeSelected: toggleType,
                            onViewAllPressed: () => showAllTypesDialog(context),
                          ),
                          AppSizedBox.height(context, 0.02),
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
                          AppSizedBox.height(context, 0.025),
                          Text(
                            'Found ${products.length} Results',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppSizedBox.height(context, 0.015),
                          products.isEmpty
                              ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 32),
                                  child: Text(
                                    'No results found',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                              : PaginatedProductList(
                                products: products,
                                scrollController: _scrollController,
                                isLoadingMore: isLoadingMore,
                              ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
