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
  });
}