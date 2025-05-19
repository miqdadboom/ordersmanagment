import 'package:flutter/material.dart';
import 'package:ordersmanagment_app/features/products/presentation/widgets/brand_and_sort_dropdowns.dart';
import 'package:ordersmanagment_app/features/products/presentation/widgets/makeup_type_dialog.dart';
import 'package:ordersmanagment_app/features/products/presentation/widgets/makeup_type_filter.dart';
import 'package:ordersmanagment_app/features/products/presentation/widgets/product_card.dart';
import 'package:ordersmanagment_app/features/products/presentation/widgets/search_bar.dart';

class FilterProductsScreen extends StatefulWidget {
  const FilterProductsScreen({super.key});

  @override
  State<FilterProductsScreen> createState() => _FilterProductsScreenState();
}

class _FilterProductsScreenState extends State<FilterProductsScreen> {
  final List<String> makeupTypes = [
    'all',
    'Lipstick',
    'Foundation',
    'Blush',
    'Mascara',
    'Concealer',
    'Powder',
    'Highlighter',
    'Bronzer',
  ];

  Set<String> selectedTypes = {'all'};
  String selectedBrand = 'All Brands';
  String sortBy = 'Default';

  final List<Map<String, String>> products = List.generate(
    10,
    (index) => {
      'image':
          'https://images.pexels.com/photos/${27085501 + index}/pexels-photo-${27085501 + index}.jpeg',
      'name': 'Product ${index + 1}',
      'brand':
          'Brand ${index % 3 == 0
              ? 'A'
              : index % 3 == 1
              ? 'B'
              : 'C'}',
      'price': '\$${(index + 5) * 2}.99',
    },
  );

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
      }
      if (selectedTypes.isEmpty) selectedTypes = {'all'};
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
      appBar: AppBar(title: const Text('Makeup'), centerTitle: true),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const SearchBarWidget(),
                    const SizedBox(height: 20),
                    MakeupTypeFilter(
                      makeupTypes: makeupTypes,
                      selectedTypes: selectedTypes,
                      onTypeSelected: toggleType,
                      onViewAllPressed: () => showAllTypesDialog(context),
                    ),
                    const SizedBox(height: 16),
                    BrandAndSortDropdowns(
                      selectedBrand: selectedBrand,
                      sortBy: sortBy,
                      onBrandChanged:
                          (value) => setState(() => selectedBrand = value!),
                      onSortChanged: (value) => setState(() => sortBy = value!),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Found ${10} Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ProductCard(
                    image: products[index]['image']!,
                    name: products[index]['name']!,
                    brand: products[index]['brand']!,
                    price: products[index]['price']!,
                    discount: index % 3 == 0 ? '10% OFF' : null,
                    onTap: () => debugPrint('Product ${index + 1} tapped'),
                  ),
                  childCount: products.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
