import 'package:flutter/cupertino.dart';

import '../../features/orders/data/models/order_model.dart';
import '../../features/orders/domain/entities/order_product.dart' as order_product;
import '../../features/orders/presentation/screens/list_of_orders_screen.dart';
import '../../features/products/presentation/screens/order_details_screen.dart';
import '../../features/products/presentation/screens/order_products_screen.dart';

final Map<String, WidgetBuilder> orderRoutes = {
  '/listOrder': (context) => ListOfOrdersScreen(),
  '/products': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final products = args['products'] as List<order_product.OrderProduct>;
    final customerName = args['customerName'] as String;

    return OrderProductsScreen(
      products: products,
      customerName: customerName,
    );
  },
  '/orderScreen': (context) {
    final order = ModalRoute.of(context)!.settings.arguments as OrderEntity;
    return OrderDetailsScreen(order: order);
  },
};
