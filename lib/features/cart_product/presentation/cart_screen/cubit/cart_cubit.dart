
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<List<Map<String, dynamic>>> {
  CartCubit() : super([]);

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> loadCartProducts() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final doc = await _firestore.collection('cart').doc(userId).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null && data['products'] != null) {
        final products = List<Map<String, dynamic>>.from(data['products']);
        emit(products);
      }
    }
  }

  Future<void> addProductToCart(Map<String, dynamic> product) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final docRef = _firestore.collection('cart').doc(userId);
    final doc = await docRef.get();

    List<Map<String, dynamic>> updatedProducts = [];

    if (doc.exists && doc.data() != null && doc.data()!['products'] != null) {
      updatedProducts = List<Map<String, dynamic>>.from(doc.data()!['products']);
    }

    final index = updatedProducts.indexWhere((p) => p['title'] == product['title']);
    if (index != -1) {
      updatedProducts[index]['quantity'] += product['quantity'];
    } else {
      updatedProducts.add(product);
    }

    await docRef.set({'products': updatedProducts});
    emit(updatedProducts);
  }

  Future<void> updateQuantity(int index, int newQty) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final updatedProducts = List<Map<String, dynamic>>.from(state);
    updatedProducts[index]['quantity'] = newQty;

    await _firestore.collection('cart').doc(userId).set({
      'products': updatedProducts,
    });

    emit(updatedProducts);
  }

  Future<void> removeProduct(int index) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final updatedProducts = List<Map<String, dynamic>>.from(state);
    updatedProducts.removeAt(index);

    await _firestore.collection('cart').doc(userId).set({
      'products': updatedProducts,
    });

    emit(updatedProducts);
  }

  double calculateTotal() {
    return state.fold(0, (sum, item) => sum + item['price'] * item['quantity']);
  }

  Future<void> clearCart() async {
    final userId = _auth.currentUser?.uid;
    if(userId == null) return;

    await _firestore.collection('cart').doc(userId).set({'products': []});

    emit([]);
  }
}