import 'package:flutter/material.dart';
import 'package:ordersmanagment_app/constants/app_colors.dart';

class BottomNavigationSalesRepresentative extends StatefulWidget {
  const BottomNavigationSalesRepresentative({super.key});

  @override
  State<BottomNavigationSalesRepresentative> createState() =>
      _BottomNavigationSalesRepresentativeState();
}

class _BottomNavigationSalesRepresentativeState
    extends State<BottomNavigationSalesRepresentative> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        // Add navigation logic here
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.backgroundColor,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.notSelectedItem,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.view_list), label: "Order"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: "Notification",
        ),
      ],
    );
  }
}
