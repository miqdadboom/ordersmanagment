import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SizeProduct extends StatefulWidget {
  const SizeProduct({super.key});

  @override
  State<SizeProduct> createState() => _SizeProductState();
}

class _SizeProductState extends State<SizeProduct> {
  String selectedSize = "M";

  void selectSize(String size) {
    setState(() {
      selectedSize = size;
    });
  }

  Widget _buildSizeCircle(String size) {
    final bool isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () => selectSize(size),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: isSelected ? AppColors.primary : AppColors.iconSize,
        child: Text(
          size,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.textLight : AppColors.textDark,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSizeCircle("S"),
        const SizedBox(width: 10),
        const Icon(Icons.chevron_right),
        const SizedBox(width: 10),
        _buildSizeCircle("M"),
        const SizedBox(width: 10),
        const Icon(Icons.chevron_right),
        const SizedBox(width: 10),
        _buildSizeCircle("L"),
      ],
    );
  }
}
