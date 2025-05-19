import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class BottomNavigationManager extends StatelessWidget {
  const BottomNavigationManager({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.selectedItemNavigation,
      unselectedItemColor: AppColors.notSelectedItemNavigation,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.view_list), label: "Order"),
        BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Product"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "Employee"),
      ],
    );
  }
}
