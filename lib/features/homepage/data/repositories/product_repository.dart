import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';

class ProductRepository extends BaseRepository<ProductEntity> {
  final FirebaseService _firebaseService = FirebaseService();

  ProductRepository() : super(FirebaseService(), 'products');

  @override
  ProductEntity fromMap(Map<String, dynamic> map, String id) {
    return ProductModel.fromMap(map, id);
  }

  @override
  Map<String, dynamic> toMap(ProductEntity item) {
    return (item as ProductModel).toMap();
  }

  Future<List<ProductEntity>> getProductsByCategory(String categoryName) async {
    final snapshot =
        await _firebaseService.firestore
            .collection(collection)
            .where('mainType', isEqualTo: categoryName)
            .get();
    return snapshot.docs
        .map((doc) => fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<List<ProductEntity>> getProductsPaginated({
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    Query query = _firebaseService.firestore
        .collection(collection)
        .orderBy('name')
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
