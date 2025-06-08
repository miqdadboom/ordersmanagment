import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/utils/app_exception.dart';

class ConfirmOrderRemoteDataSource {
  static Future<void> checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      throw NoInternetException();
    }
  }

  static Future<void> sendOrderToFirebase({
    required String customerName,
    required String location,
    required double latitude,
    required double longitude,
    required List<Map<String, dynamic>> products,
  }) async {
    try {
      final initialStatus = await Connectivity().checkConnectivity();
      if (initialStatus == ConnectivityResult.none) {
        throw NoInternetException();
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw ServerException('Please login first');
      }
      final userId = currentUser.uid;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw ServerException('User data not found');
      }

      final userRole = userDoc.data()?['role'] ?? 'user';
      final userEmail = userDoc.data()?['email'] ?? 'user';

      if (products.isEmpty) {
        throw ParseException();
      }

      late StreamSubscription<ConnectivityResult> subscription;
      final completer = Completer<void>();

      subscription = Connectivity().onConnectivityChanged.listen(
            (status) async {
          if (status != ConnectivityResult.none) {
            try {
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

              await FirebaseFirestore.instance
                  .collection('notifications')
                  .add({
                'title': 'New Order',
                'body': 'A new order has been received from $customerName',
                'timestamp': DateTime.now().toIso8601String(),
                'isRead': false,
                'userEmail': userEmail,
              });

              await subscription.cancel();
              completer.complete();
            } catch (e) {
              await subscription.cancel();
              completer.completeError(e);
            }
          }
        },
      );

      await completer.future;
    } on FirebaseAuthException catch (e) {
      throw ServerException('Authentication error: ${e.message}');
    } on FirebaseException catch (e) {
      throw ServerException('Database error: ${e.message}');
    } on SocketException {
      throw NoInternetException();
    } on FormatException {
      throw ParseException();
    } catch (e) {
      throw UnknownException('An unexpected error occurred: $e');
    }
  }
}
