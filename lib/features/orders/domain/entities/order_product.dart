// lib/features/orders/domain/entities/order_product.dart
class OrderProduct {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final bool passed;
  final String? imageUrl;
  final String customerName;

  const OrderProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.passed,
    this.imageUrl,
    required this.customerName,
  });
}