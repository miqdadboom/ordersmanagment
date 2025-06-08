import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfirmOrderRemoteDataSource {
  static Future<void> sendOrderToFirebase({
    required String customerName,
    required String location,
    required double latitude,
    required double longitude,
    required List<Map<String, dynamic>> products,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final userId = currentUser.uid;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      
      final userRole = userDoc.data()?['role'] ?? 'user';
      final userEmail = userDoc.data()?['email'] ?? 'user';

      await FirebaseFirestore.instance.collection('orders').add({
        'createdBy': userId,
        'customerName': customerName,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.now().toIso8601String(),
        'products': products,
        'userRole': userRole,
        'userEmail': userEmail,
      });

      await FirebaseFirestore.instance.collection('notifications').add({
        'title': 'new order',
        'body': 'A new order has arrived from $customerName ',
        'timestamp': DateTime.now().toIso8601String(),
        'isRead': false,
        'userEmail': userEmail,
      });
    } on FirebaseException catch (e) {
      throw Exception('Firebase error: ${e.message}');
    }
    on SocketException {
      throw Exception('No internet connection. Please check your network.');
    }
    on FormatException {
      throw Exception('Invalid data format encountered.');
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }
}
