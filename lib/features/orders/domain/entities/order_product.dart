// lib/features/orders/domain/entities/order_product.dart
class OrderProduct {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final bool? passed;
  final String imageUrl;

  const OrderProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    this.passed,
    required this.imageUrl,
  });
}
