import 'package:flutter/material.dart';
import '../../../features/products/presentation/screens/products_screen.dart';
import '../../../features/products/presentation/screens/filter_products.dart';
import '../../../features/products/presentation/screens/product_view.dart';
import '../../features/cart_product/presentation/cart_screen/screens/cart_screen.dart';

final Map<String, WidgetBuilder> productRoutes = {
  '/cartScreen': (context) => const CartScreen(),
  '/productScreen': (context) => ProductsScreen(),
  '/filterProductScreen': (context) => FilterProductsScreen(),
  '/productView': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ProductView(
      imageUrl: args['imageUrl'],
      name: args['name'],
      brand: args['brand'],
      price: args['price'],
    );
  },
};
