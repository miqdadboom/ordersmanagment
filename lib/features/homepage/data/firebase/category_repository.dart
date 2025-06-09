import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/category.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Category>> getCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> addCategory(Category category) async {
    await _firestore
        .collection('categories')
        .add(
          CategoryModel(
            id: category.id,
            name: category.name,
            imageUrl: category.imageUrl,
            subtypes: category.subtypes,
          ).toMap(),
        );
  }

  Future<void> updateCategory(String documentId, Category category) async {
    await _firestore
        .collection('categories')
        .doc(documentId)
        .update(
          CategoryModel(
            id: category.id,
            name: category.name,
            imageUrl: category.imageUrl,
            subtypes: category.subtypes,
          ).toMap(),
        );
  }

  Future<void> deleteCategory(String documentId) async {
    await _firestore.collection('categories').doc(documentId).delete();
  }
}
