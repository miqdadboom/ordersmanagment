import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getProducts() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['documentId'] = doc.id;
      return data;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(
    String categoryName,
  ) async {
    final snapshot =
        await _firestore
            .collection('products')
            .where('mainType', isEqualTo: categoryName)
            .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> addProduct(Map<String, dynamic> product) async {
    await _firestore.collection('products').add(product);
  }

  Future<void> updateProduct(
    String documentId,
    Map<String, dynamic> product,
  ) async {
    await _firestore.collection('products').doc(documentId).update(product);
  }

  Future<void> deleteProduct(String documentId) async {
    await _firestore.collection('products').doc(documentId).delete();
  }
}
