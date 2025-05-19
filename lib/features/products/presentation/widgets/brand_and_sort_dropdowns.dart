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
    const dropdownTextStyle = TextStyle(
      color: AppColors.primary,
      fontSize: 14, // حجم الخط المعدل
      fontWeight: FontWeight.w500,
    );

    return Row(
      children: [
        // Dropdown العلامة التجارية
        Expanded(
          child: Container(
            height: 40,
            alignment: Alignment.center, // محاذاة النص في المنتصف
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
                selectedItemBuilder: (BuildContext context) {
                  return ['All Brands', 'Brand A', 'Brand B'].map<Widget>((
                    String item,
                  ) {
                    return Align(
                      alignment: Alignment.centerLeft, // محاذاة النص
                      child: Text(
                        item == 'All Brands' ? 'Brand' : item,
                        style: dropdownTextStyle.copyWith(
                          fontSize: 14, // حجم الخط عند التحديد
                        ),
                      ),
                    );
                  }).toList();
                },
                items: const [
                  DropdownMenuItem(
                    value: 'All Brands',
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Brand', style: dropdownTextStyle),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Brand A',
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Brand A', style: dropdownTextStyle),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Brand B',
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Brand B', style: dropdownTextStyle),
                    ),
                  ),
                ],
                onChanged: onBrandChanged,
                dropdownColor: Colors.white,
                icon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
                iconSize: 24, // حجم أيقونة السهم
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Dropdown الترتيب
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
                selectedItemBuilder: (BuildContext context) {
                  return ['Default', 'PriceLow', 'PriceHigh'].map<Widget>((
                    String item,
                  ) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item == 'Default'
                            ? 'Sort'
                            : item == 'PriceLow'
                            ? 'Price: Low to High'
                            : 'Price: High to Low',
                        style: dropdownTextStyle.copyWith(fontSize: 14),
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
                      child: Text(
                        'Price: Low to High',
                        style: dropdownTextStyle,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'PriceHigh',
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Price: High to Low',
                        style: dropdownTextStyle,
                      ),
                    ),
                  ),
                ],
                onChanged: onSortChanged,
                dropdownColor: Colors.white,
                icon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
                iconSize: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}