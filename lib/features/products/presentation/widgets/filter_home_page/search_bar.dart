import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchBarWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return TextField(
      onChanged: onChanged,
      style: TextStyle(
        fontSize: screenWidth * 0.04, // ~16
      ),
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: TextStyle(fontSize: screenWidth * 0.04),
        prefixIcon: Icon(
          Icons.search,
          size: screenWidth * 0.06, // ~24
        ),
        filled: true,
        fillColor: AppColors.searchBar,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.025), // ~10
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.03, // ~12
          horizontal: screenWidth * 0.04, // ~16
        ),
      ),
    );
  }
}
