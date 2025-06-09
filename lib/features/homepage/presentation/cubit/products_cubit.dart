import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';

class ProductsCubit extends Cubit<List<ProductEntity>> {
  final ProductsRepository repository;

  ProductsCubit(this.repository) : super([]);

  Future<void> loadProducts() async {
    try {
      emit([]); // Show loading state
      final products = await repository.getProducts();
      emit(products);
    } catch (e) {
      emit([]); // In real app, you might want an error state
    }
  }

  Future<void> addProduct(ProductEntity product) async {
    await repository.addProduct(product);
    await loadProducts(); // Refresh the list
  }

  Future<void> updateProduct(ProductEntity product) async {
    await repository.updateProduct(product);
    await loadProducts(); // Refresh the list
  }

  Future<void> deleteProduct(String productId) async {
    await repository.deleteProduct(productId);
    await loadProducts(); // Refresh the list
  }
}