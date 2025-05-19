import 'package:flutter/material.dart';
import 'package:ordersmanagment_app/constants/app_colors.dart';

class BrandAndSortDropdowns extends StatelessWidget {
  final String selectedBrand;
  final String sortBy;
  final ValueChanged<String?> onBrandChanged;
  final ValueChanged<String?> onSortChanged;

  const BrandAndSortDropdowns({
    super.key,
    required this.selectedBrand,
    required this.sortBy,
    required this.onBrandChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.selectionFieldEdges),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedBrand,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'All Brands', child: Text('Brand')),
                  DropdownMenuItem(value: 'Brand A', child: Text('Brand A')),
                  DropdownMenuItem(value: 'Brand B', child: Text('Brand B')),
                ],
                onChanged: onBrandChanged,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.selectionFieldEdges),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: sortBy,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'Default', child: Text('Sort')),
                  DropdownMenuItem(
                    value: 'PriceLow',
                    child: Text('Price: Low to High'),
                  ),
                  DropdownMenuItem(
                    value: 'PriceHigh',
                    child: Text('Price: High to Low'),
                  ),
                ],
                onChanged: onSortChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
