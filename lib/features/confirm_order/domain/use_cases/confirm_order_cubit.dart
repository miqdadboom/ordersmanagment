import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_exception.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../orders/domain/entities/order_product.dart';
import '../../data/datasources/confirm_order_remote_data_source.dart';
import '../../../../core/widgets/place.dart';

class ConfirmOrderCubit {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  PlaceLocation? selectedLocation;
  bool isLoading = false;

  bool validateOrderInputs(BuildContext context) {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      showValidationDialog(context, 'Please enter your name.');
      return false;
    }

    if (selectedLocation == null) {
      showValidationDialog(context, 'Please select your location.');
      return false;
    }

    return true;
  }

  void showValidationDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Validation Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void updateLocation(PlaceLocation location) {
    selectedLocation = location;
  }

  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

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
      notes: notesController.text.trim(),
      latitude: selectedLocation!.latitude,
      longitude: selectedLocation!.longitude,
      status: 'Pending',
      estimatedTime: '2 hours',
      products: products,
      productImage: products.isNotEmpty ? cartProducts[0]['imageUrl'] : null,
      createdBy: getCurrentUserId(),
    );
  }

  Future<void> sendOrderToFirebase({
    required BuildContext context,
    required List<Map<String, dynamic>> cartProducts,
  }) async {
    if (!validateOrderInputs(context)) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      isLoading = true;

      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw SocketException('No internet connection');
      }

      final products = cartProducts.map((item) => {
        'title': item['title'] ?? 'Untitled',
        'price': item['price'] ?? 0,
        'quantity': item['quantity'] ?? 1,
        'imageUrl': item['imageUrl'],
      }).toList();

      await ConfirmOrderRemoteDataSource.sendOrderToFirebase(
        customerName: nameController.text.trim(),
        location: selectedLocation!.address,
        latitude: selectedLocation!.latitude,
        longitude: selectedLocation!.longitude,
        products: products,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order sent successfully!')),
      );
    } catch (e) {
      AppExceptionHandler.handle(context: context, error: e);
    } finally {
      if (Navigator.canPop(context)) Navigator.of(context).pop();
      isLoading = false;
    }
  }
}
