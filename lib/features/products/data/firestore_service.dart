// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class FirestoreService {
//   static Future<void> saveProduct({
//     required String name,
//     required String brand,
//     required double price,
//     required String description,
//     required String imageUrl,
//   }) async {
//     try {
//       await FirebaseFirestore.instance.collection('products').add({
//         'name': name,
//         'brand': brand,
//         'price': price,
//         'description': description,
//         'imageUrl': imageUrl,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       debugPrint("🔥 Error saving product: $e");
//       rethrow;
//     }
//   }
// }
