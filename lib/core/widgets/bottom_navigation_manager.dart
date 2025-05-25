import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class BottomNavigationManager extends StatefulWidget {
  const BottomNavigationManager({super.key});

  @override
  State<BottomNavigationManager> createState() => _BottomNavigationManager();
}

class _BottomNavigationManager extends State<BottomNavigationManager> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/productScreen');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/cartScreen');
        break;
      default:
        // Order (1) and Notification (3) not implemented yet
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.primary,
      selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
      unselectedItemColor: AppColors.notSelectedItem,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.view_list), label: "Order"),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: "Product",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: "Employee",
        ),
      ],
    );
  }
}
