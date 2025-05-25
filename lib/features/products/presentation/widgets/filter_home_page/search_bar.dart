import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchBarWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged, // ✅ استخدم الدالة الممرّرة
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: AppColors.searchBar,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
