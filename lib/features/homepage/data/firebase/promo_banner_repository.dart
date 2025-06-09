import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/promo_banner.dart';

class PromoBannerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _collection = 'promo_banners';

  Future<String> uploadImage(File imageFile) async {
    final storageRef = _storage.ref().child(
      'promo_banners/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    final bytes = await imageFile.readAsBytes();
    await storageRef.putData(bytes);
    return await storageRef.getDownloadURL();
  }

  Future<void> addBanner({
    required String title,
    required String description,
    required String imageUrl,
  }) async {
    await _firestore.collection(_collection).add({
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<PromoBanner>> getBanners() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => PromoBanner.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Future<void> updateBanner({
    required String bannerId,
    String? title,
    String? description,
    String? imageUrl,
  }) async {
    final Map<String, dynamic> updates = {};
    if (title != null) updates['title'] = title;
    if (description != null) updates['description'] = description;
    if (imageUrl != null) updates['imageUrl'] = imageUrl;
    await _firestore.collection(_collection).doc(bannerId).update(updates);
  }

  Future<void> deleteBanner(String bannerId) async {
    await _firestore.collection(_collection).doc(bannerId).delete();
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}
