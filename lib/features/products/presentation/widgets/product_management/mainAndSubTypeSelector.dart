import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';

class MainAndSubTypeSelector extends StatefulWidget {
  final Function(String mainType, String subType) onChanged;

  const MainAndSubTypeSelector({super.key, required this.onChanged});

  @override
  State<MainAndSubTypeSelector> createState() => _MainAndSubTypeSelectorState();
}

class _MainAndSubTypeSelectorState extends State<MainAndSubTypeSelector> {
  final List<String> mainTypes = ['Makeup', 'Skincare', 'Haircare'];

  final Map<String, List<String>> subTypesMap = {
    'Makeup': ['Lipstick', 'Foundation', 'Blush', 'Mascara'],
    'Skincare': ['Moisturizer', 'Cleanser', 'Toner'],
    'Haircare': ['Shampoo', 'Conditioner', 'Serum'],
  };

  String? selectedMainType;
  String? selectedSubType;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.015), // ~12
        Text(
          "Main Type",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.04, // ~16
          ),
        ),
        SizedBox(height: screenHeight * 0.01), // ~8
        DropdownButtonFormField<String>(
          value: selectedMainType,
          decoration: _buildDropdownDecoration("Select main type", screenWidth),
          items:
              mainTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
          onChanged: (value) {
            setState(() {
              selectedMainType = value;
              selectedSubType = null;
              widget.onChanged(selectedMainType ?? '', '');
            });
          },
        ),

        SizedBox(height: screenHeight * 0.02), // ~16
        Text(
          "Sub Type",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.04,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        DropdownButtonFormField<String>(
          value: selectedSubType,
          decoration: _buildDropdownDecoration("Select sub type", screenWidth),
          items:
              (selectedMainType != null
                      ? subTypesMap[selectedMainType] ?? []
                      : [])
                  .map<DropdownMenuItem<String>>(
                    (sub) =>
                        DropdownMenuItem<String>(value: sub, child: Text(sub)),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              selectedSubType = value;
              widget.onChanged(selectedMainType ?? '', selectedSubType ?? '');
            });
          },
        ),
      ],
    );
  }

  InputDecoration _buildDropdownDecoration(String hint, double screenWidth) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.primary,
        fontSize: screenWidth * 0.035, // ~14
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03), // ~12
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      filled: true,
      fillColor: AppColors.background,
    );
  }
}
