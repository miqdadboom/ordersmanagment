// lib/features/confirm_order/presentation/cubit/confirm_order_controller.dart

import 'package:flutter/material.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../orders/domain/entities/order_product.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../data/datasources/confirm_order_remote_data_source.dart';
import '../../../../core/widgets/place.dart';

class ConfirmOrderController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  PlaceLocation? selectedLocation;

  List<OrderProduct> convertToOrderProducts(List<Map<String, dynamic>> rawProducts) {
    return rawProducts.map((p) {
      return OrderProduct(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: p['title'] ?? 'Unknown',
        description: p['subtitle'] ?? '',
        quantity: p['quantity'] ?? 1,
        passed: true,
        imageUrl: p['imageUrl'],
      );
    }).toList();
  }

  OrderEntity? createOrder(List<Map<String, dynamic>> cartProducts) {
    final name = nameController.text.trim();
    if (selectedLocation == null || name.isEmpty) return null;

    final products = convertToOrderProducts(cartProducts);

    return OrderEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: name,
      customerAddress: selectedLocation!.address,
      latitude: selectedLocation!.latitude,
      longitude: selectedLocation!.longitude,
      status: 'Pending',
      estimatedTime: '2 hours',
      products: products,
      productImage: products.isNotEmpty ? cartProducts[0]['imageUrl'] : null,
    );
  }

  Future<void> sendOrderToFirebase({
    required BuildContext context,
    required List<Map<String, dynamic>> cartProducts,
  }) async {
    final name = nameController.text.trim();
    if (selectedLocation == null || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter name and select location')),
      );
      return;
    }

    final products = cartProducts.map((item) => {
      'title': item['title'] ?? 'Untitled',
      'price': item['price'] ?? 0,
      'quantity': item['quantity'] ?? 1,
      'imageUrl': item['imageUrl'],
    }).toList();

    await ConfirmOrderRemoteDataSource.sendOrderToFirebase(
      customerName: name,
      location: selectedLocation!.address,
      latitude: selectedLocation!.latitude,
      longitude: selectedLocation!.longitude,
      products: products,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order sent successfully!')),
    );
  }
}
