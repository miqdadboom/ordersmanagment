import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';

class BottomNavigationWarehouseManager extends StatefulWidget {
  const BottomNavigationWarehouseManager({super.key});

  @override
  State<BottomNavigationWarehouseManager> createState() =>
      _BottomNavigationWarehouseManager();
}

class _BottomNavigationWarehouseManager
    extends State<BottomNavigationWarehouseManager> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentRoute = ModalRoute.of(context)?.settings.name;
    switch (currentRoute) {
      case '/ProductsScreen':
        _currentIndex = 0;
        break;
      case '/listOrder':
        _currentIndex = 1;
        break;
      case '/cartScreen':
        _currentIndex = 2;
        break;
      case '/notificationList':
        _currentIndex = 3;
        break;
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/ProductsScreen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/listOrder');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/cartScreen');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/notificationList');
        break;
      default:
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
          label: "Cart",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: "Notification",
        ),
      ],
    );
  }
}
