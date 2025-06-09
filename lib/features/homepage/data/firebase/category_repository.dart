import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/category.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Category>> getCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList();
  }

  Future<void> addCategory(Category category) async {
    await _firestore.collection('categories').add(category.toJson());
  }

  Future<void> updateCategory(String documentId, Category category) async {
    await _firestore
        .collection('categories')
        .doc(documentId)
        .update(category.toJson());
  }

  Future<void> deleteCategory(String documentId) async {
    await _firestore.collection('categories').doc(documentId).delete();
  }
}
