class ProductEntity {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final String categoryId;
  final String title;
  final String brand;
  final int quantity;

  ProductEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.title,
    required this.brand,
    required this.quantity,
  });
}
