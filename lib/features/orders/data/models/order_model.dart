// lib/domain/entities/order_entity.dart
import '../../domain/entities/order_product.dart';

class OrderEntity {
  final String id;
  final String customerName;
  final String customerAddress;
  final String status; // 'Pass', 'Pending', 'Failed'
  final String estimatedTime; // e.g. '3 hours'
  final String? productImage; // URL or null
  final List<OrderProduct> products;
  final double? latitude;
  final double? longitude;
  final String createdBy;
  final String? notes;

  const OrderEntity({
    required this.id,
    required this.customerName,
    required this.customerAddress,
    required this.status,
    required this.estimatedTime,
    this.productImage,
    required this.products,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    this.notes,
  });


  factory OrderEntity.fromMap(Map<String, dynamic> data, String id) {
    final List<OrderProduct> products = (data['products'] as List<dynamic>).map((item) {
      return OrderProduct(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: item['title'] ?? 'Unknown',
        description: '',
        quantity: item['quantity'] ?? 1,
        passed: true,
        imageUrl: item['imageUrl'],
      );
    }).toList();

    return OrderEntity(
      id: id,
      customerName: data['customerName'] ?? 'Unknown',
      customerAddress: data['location'] ?? 'Unknown',
      notes: data['notes'],
      status: 'Pending',
      estimatedTime: '2 hours',
      products: products,
      productImage: products.isNotEmpty ? products[0].imageUrl : null,
      latitude: data['latitude'],
      longitude: data['longitude'],
      createdBy: data['createdBy'] ?? '',
    );
  }

}