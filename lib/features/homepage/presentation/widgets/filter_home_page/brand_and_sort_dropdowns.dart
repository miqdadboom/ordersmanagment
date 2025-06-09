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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final dropdownTextStyle = TextStyle(
      color: AppColors.primary,
      fontSize: screenWidth * 0.035, // ~14
      fontWeight: FontWeight.w500,
    );

    return Row(
      children: [
        Expanded(
          child: Container(
            height: screenHeight * 0.05, // ~40
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
            ), // ~12
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(screenWidth * 0.025), // ~10
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
                items:
                    availableBrands.map<DropdownMenuItem<String>>((
                      String brand,
                    ) {
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
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.primary,
                  size: screenWidth * 0.06,
                ), // ~24
                dropdownColor: Colors.white,
              ),
            ),
          ),
        ),

        SizedBox(width: screenWidth * 0.02), // ~8

        Expanded(
          child: Container(
            height: screenHeight * 0.05, // ~40
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(screenWidth * 0.025),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: sortBy,
                isExpanded: true,
                style: dropdownTextStyle,
                selectedItemBuilder: (context) {
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
                        style: dropdownTextStyle,
                      ),
                    );
                  }).toList();
                },
                items: [
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
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.primary,
                  size: screenWidth * 0.06,
                ),
                dropdownColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
