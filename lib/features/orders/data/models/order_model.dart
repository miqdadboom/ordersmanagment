// lib/domain/entities/order_entity.dart
import '../../domain/entities/order_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderEntity {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final List<OrderProduct> products;
  final double totalAmount;
  final DateTime createdAt;
  final String status; // 'Pending', 'Passed', 'Failed'
  final String estimatedTime;
  final String? productImage;
  final double? latitude;
  final double? longitude;
  final String createdBy;
  final String? notes;

  OrderEntity({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.products,
    required this.totalAmount,
    required this.createdAt,
    required this.status,
    required this.estimatedTime,
    this.productImage,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    this.notes,
  });

  factory OrderEntity.fromMap(Map<String, dynamic> data) {
    final List<OrderProduct> products =
        (data['products'] as List<dynamic>).map((item) {
          return OrderProduct(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: item['title'] ?? 'Unknown',
            description: '',
            quantity: item['quantity'] ?? 1,
            passed: item['passed'],
            imageUrl: item['imageUrl'] ?? '',
          );
        }).toList();

    // Calculate order status based on products
    String calculateOrderStatus() {
      if (products.isEmpty) return 'Pending';

      bool hasPending = false;
      bool hasFailed = false;
      bool hasPassed = false;

      for (var product in products) {
        if (product.passed == null) {
          hasPending = true;
        } else if (product.passed == true) {
          hasPassed = true;
        } else {
          hasFailed = true;
        }
      }

      if (hasPending) return 'Pending';
      if (hasFailed) return 'Failed';
      return 'Passed';
    }

    return OrderEntity(
      id: data['id'] ?? '',
      customerName: data['customerName'] ?? '',
      customerPhone: data['customerPhone'] ?? '',
      customerAddress: data['customerAddress'] ?? '',
      products: products,
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      status: calculateOrderStatus(),
      estimatedTime: data['estimatedTime'] ?? '2 hours',
      productImage: products.isNotEmpty ? products[0].imageUrl : null,
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      createdBy: data['createdBy'] ?? '',
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'products':
          products
              .map(
                (product) => {
                  'title': product.name,
                  'quantity': product.quantity,
                  'passed': product.passed,
                  'imageUrl': product.imageUrl,
                },
              )
              .toList(),
      'totalAmount': totalAmount,
      'createdAt': createdAt,
      'status': status,
      'estimatedTime': estimatedTime,
      'productImage': productImage,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'notes': notes,
    };
  }
}
