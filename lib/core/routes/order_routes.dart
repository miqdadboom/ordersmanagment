import 'package:flutter/material.dart';
import '../../../features/orders/presentation/screens/list_of_orders_screen.dart';
import '../../../features/products/presentation/screens/order_products_screen.dart';
import '../../../features/orders/data/models/order_model.dart';
import '../../../features/products/presentation/screens/order_details_screen.dart';
import '../../../features/orders/domain/entities/order_product.dart'
    as order_product;

final Map<String, WidgetBuilder> orderRoutes = {
  '/listOrder': (context) => ListOfOrdersScreen(),
  '/products': (context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Map<String, dynamic>) {
      final products =
          args['products'] as List<order_product.OrderProduct>? ??
          <order_product.OrderProduct>[];
      final orderId = args['orderId'] as String? ?? '';
      return OrderProductsScreen(products: products, orderId: orderId);
    } else if (args is List<order_product.OrderProduct>) {
      // Fallback for old usage, but orderId is required, so show error or use empty string
      return OrderProductsScreen(products: args, orderId: '');
    } else {
      return OrderProductsScreen(
        products: <order_product.OrderProduct>[],
        orderId: '',
      );
    }
  },
  '/orderScreen': (context) {
    final order = ModalRoute.of(context)!.settings.arguments as OrderEntity;
    return OrderDetailsScreen(order: order);
  },
};
