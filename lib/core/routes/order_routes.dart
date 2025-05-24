import 'package:flutter/material.dart';
import '../../../features/orders/presentation/screens/list_of_orders_screen.dart';
import '../../../features/products/presentation/screens/order_products_screen.dart';
import '../../../features/orders/data/models/order_model.dart';
import '../../../features/products/presentation/screens/order_details_screen.dart';
import '../../../features/orders/domain/entities/order_product.dart' as order_product;

final Map<String, WidgetBuilder> orderRoutes = {
  '/listOrder': (context) => ListOfOrdersScreen(),
  '/products': (context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final products = args is List<order_product.OrderProduct>
        ? args
        : <order_product.OrderProduct>[];
    return OrderProductsScreen(products: products);
  },
  '/orderScreen': (context) {
    final order = ModalRoute.of(context)!.settings.arguments as OrderEntity;
    return OrderDetailsScreen(order: order);
  },
};
