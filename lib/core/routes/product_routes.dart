import 'package:final_tasks_front_end/features/cart_product/presentation/cart_screen/screens/product_view_cart.dart';
import 'package:final_tasks_front_end/features/products/presentation/screens/product_management.dart';
import 'package:final_tasks_front_end/features/products/presentation/screens/products_screen.dart';
import 'package:flutter/material.dart';
import '../../../features/products/presentation/screens/filter_products.dart';
import '../../../features/products/presentation/screens/product_view.dart';
import '../../features/cart_product/presentation/cart_screen/screens/cart_screen.dart';

final Map<String, WidgetBuilder> productRoutes = {
  '/cartScreen': (context) => const CartScreen(),
  '/ProductsScreen': (context) => ProductsScreen(),
  '/ProductManagementScreen': (context) => ProductManagementScreen(),
  '/filterProductScreen':
      (context) => FilterProductsScreen(categoryName: 'All'),
  '/productView': (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ProductView(
      imageUrl: args['imageUrl'],
      name: args['name'],
      brand: args['brand'],
      price: args['price'],
      description: args['description'] is String ? args['description'] : '',
    );
  },
  '/productViewCart': (context) {
    final args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ProductViewCart(
      imageUrl: args['imageUrl'],
      name: args['name'],
      brand: args['brand'],
      price: args['price'],
      description: args['description'] is String ? args['description'] : '',
    );
  },
};
