import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';

class BrandAndSortDropdowns extends StatelessWidget {
  final List<String> availableBrands;
  final String selectedBrand;
  final String sortBy;
  final ValueChanged<String?> onBrandChanged;
  final ValueChanged<String?> onSortChanged;

  const BrandAndSortDropdowns({
    super.key,
    required this.availableBrands,
    required this.selectedBrand,
    required this.sortBy,
    required this.onBrandChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    const dropdownTextStyle = TextStyle(
      color: AppColors.primary,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    return Row(
      children: [
        // 🟦 Brand Dropdown
        Expanded(
          child: Container(
            height: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedBrand,
                isExpanded: true,
                style: dropdownTextStyle,
                selectedItemBuilder: (context) {
                  return availableBrands.map<Widget>((String item) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item == 'All Brands' ? 'Brand' : item,
                        style: dropdownTextStyle,
                      ),
                    );
                  }).toList();
                },
                items: availableBrands.map<DropdownMenuItem<String>>((String brand) {
                  return DropdownMenuItem<String>(
                    value: brand,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        brand == 'All Brands' ? 'Brand' : brand,
                        style: dropdownTextStyle,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onBrandChanged,
                icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                iconSize: 24,
                dropdownColor: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // 🟦 Sort Dropdown
        Expanded(
          child: Container(
            height: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: sortBy,
                isExpanded: true,
                style: dropdownTextStyle,
                selectedItemBuilder: (context) {
                  return ['Default', 'PriceLow', 'PriceHigh'].map<Widget>((String item) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item == 'Default'
                            ? 'Sort'
                            : item == 'PriceLow'
                                ? 'Price: Low to High'
                                : 'Price: High to Low',
                        style: dropdownTextStyle,
                      ),
                    );
                  }).toList();
                },
                items: const [
                  DropdownMenuItem(
                    value: 'Default',
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Sort', style: dropdownTextStyle),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'PriceLow',
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Price: Low to High', style: dropdownTextStyle),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'PriceHigh',
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Price: High to Low', style: dropdownTextStyle),
                    ),
                  ),
                ],
                onChanged: onSortChanged,
                icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                iconSize: 24,
                dropdownColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}