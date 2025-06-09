// lib/products/domain/use_cases/get_products.dart
import '../entities/product_entity.dart';
import '../repositories/products_repository.dart';

class GetProducts {
  final ProductsRepository repository;

  GetProducts(this.repository);

  Future<List<ProductEntity>> execute() async {
    return await repository.getProducts();
  }
}