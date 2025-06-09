import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/utils/user_access_control.dart';
import '../../../../core/widgets/bottom_navigation_manager.dart';
import '../../../../core/widgets/bottom_navigation_sales_representative.dart';
import '../../../../core/widgets/bottom_navigation_warehouse_manager.dart';
import '../../../homepage/presentation/screens/home_page.dart';

class HomeScreenByRole extends StatelessWidget {
  final String role;

  const HomeScreenByRole({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!UserAccessControl.HomeScreen(role)) {
      return const Scaffold(body: Center(child: Text("Unauthorized")));
    }

    Widget bottomBar;

    if (role == 'admin') {
      bottomBar = const BottomNavigationManager();
    } else if (role == 'salesRepresentative') {
      bottomBar = const BottomNavigationSalesRepresentative();
    } else if (role == 'warehouseEmployee') {
      bottomBar = const BottomNavigationWarehouseManager();
    } else {
      return const Scaffold(body: Center(child: Text("Unknown role")));
    }

    return Scaffold(body: ProductsScreen());
  }
}
