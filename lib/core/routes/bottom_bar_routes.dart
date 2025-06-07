import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_manager.dart';
import '../widgets/bottom_navigation_sales_representative.dart';
import '../widgets/bottom_navigation_warehouse_manager.dart';

final Map<String, WidgetBuilder> bottomBarRoutes = {
  '/bottomManager': (context) => const BottomNavigationManager(),
  '/bottomSales': (context) => const BottomNavigationSalesRepresentative(),
  '/bottomWarehouse': (context) => const BottomNavigationWarehouseManager(),
};
