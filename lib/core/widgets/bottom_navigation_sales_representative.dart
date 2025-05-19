import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class BottomNavigationSalesRepresentative extends StatelessWidget {
  const BottomNavigationSalesRepresentative({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFFD3D5D7),
      selectedItemColor: AppColors.selectedItemNavigation,
      unselectedItemColor: AppColors.notSelectedItemNavigation,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.view_list), label: "Order"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: "Notification"),
      ],
    );
  }
}
