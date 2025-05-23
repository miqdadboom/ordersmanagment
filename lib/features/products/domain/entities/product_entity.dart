// lib/products/domain/entities/product_entity.dart
class ProductEntity {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final String status;
  final String? imageUrl;

  ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.status,
    this.imageUrl,
  });
}