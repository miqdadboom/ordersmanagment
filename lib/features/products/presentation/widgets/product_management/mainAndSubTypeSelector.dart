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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text("Main Type", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedMainType,
          decoration: _buildDropdownDecoration("Select main type"),
          items:
              mainTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
          onChanged: (value) {
            setState(() {
              selectedMainType = value;
              selectedSubType = null; // reset subtype
              widget.onChanged(selectedMainType ?? '', '');
            });
          },
        ),

        const SizedBox(height: 16),
        const Text("Sub Type", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedSubType,
          decoration: _buildDropdownDecoration("Select sub type"),
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

  InputDecoration _buildDropdownDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.primary),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      filled: true,
      fillColor: AppColors.background,
    );
  }
}