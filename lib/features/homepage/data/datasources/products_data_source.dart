// lib/products/data/datasources/products_datasource.dart
import '../../domain/entities/product_entity.dart';

abstract class ProductsDataSource {
  Future<List<ProductEntity>> fetchProducts();
  Future<String> addProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
  Future<void> deleteProduct(String productId);
}

// Example API implementation
class ProductsApiDataSource implements ProductsDataSource {
  @override
  Future<List<ProductEntity>> fetchProducts() async {
    // In a real app, this would call your API
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [
      ProductEntity(
        id: '1',
        name: 'Product 1',
        description: 'Description for product 1',
        quantity: 10,
        status: 'available',
        imageUrl: null,
      ),
      // Add more mock products as needed
    ];
  }

  @override
  Future<String> addProduct(ProductEntity product) {
    // Implementation would go here
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProduct(String productId) {
    // Implementation would go here
    throw UnimplementedError();
  }

  @override
  Future<void> updateProduct(ProductEntity product) {
    // Implementation would go here
    throw UnimplementedError();
  }
}