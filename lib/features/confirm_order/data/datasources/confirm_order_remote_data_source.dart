import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmOrderRemoteDataSource {
  static Future<void> sendOrderToFirebase({
    required String customerName,
    required String location,
    required double latitude,
    required double longitude,
    required List<Map<String, dynamic>> products,
  }) async {
    await FirebaseFirestore.instance.collection('orders').add({
      'customerName': customerName,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': DateTime.now().toIso8601String(),
      'products': products,
    });

    await FirebaseFirestore.instance.collection('notifications').add({
      'title': 'new order',
      'body': 'A new order has arrived from $customerName ',
      'timestamp': DateTime.now().toIso8601String(),
      'isRead': false,
    });
  }
}
