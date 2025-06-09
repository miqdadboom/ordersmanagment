import '../../domain/entities/product_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required String id,
    required String name,
    required String imageUrl,
    required double price,
    required String description,
    required String categoryId,
    required String title,
    required String brand,
    required int quantity,
  }) : super(
         id: id,
         name: name,
         imageUrl: imageUrl,
         price: price,
         description: description,
         categoryId: categoryId,
         title: title,
         brand: brand,
         quantity: quantity,
       );

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      categoryId: map['categoryId'] ?? '',
      title: map['title'] ?? '',
      brand: map['brand'] ?? '',
      quantity: (map['quantity'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'description': description,
      'categoryId': categoryId,
      'title': title,
      'brand': brand,
      'quantity': quantity,
    };
  }
}
