import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/order_model.dart';
import '../../domain/entities/order_product.dart';
import '../../domain/repositories/orders_repository.dart';

class OrdersCubit extends Cubit<List<OrderEntity>> {
  final OrderRepository repository;

  List<OrderEntity> allOrdersBackup = [];

  OrdersCubit(this.repository) : super([]);

  Future<void> loadOrderByRole({
    required String role,
    required String userId,
  }) async {
    try {
      print('Loading orders for role: $role, userId: $userId');

      final snapshot =
          await FirebaseFirestore.instance
              .collection('orders')
              .orderBy('createdAt', descending: true)
              .get();

      print('Found ${snapshot.docs.length} orders in Firestore');

      if (snapshot.docs.isEmpty) {
        print('No orders found in Firestore');
        emit([]);
        return;
      }

      final List<OrderEntity> allOrders =
          snapshot.docs.map((doc) {
            final data = doc.data();
            print('Processing order: ${doc.id}');
            print('Order data: $data');

            final List<OrderProduct> products =
                (data['products'] as List<dynamic>).map((item) {
                  return OrderProduct(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: item['title'] ?? 'Unknown',
                    description: '',
                    quantity: item['quantity'] ?? 1,
                    passed: item['passed'],
                    imageUrl: item['imageUrl'] ?? '',
                  );
                }).toList();

            return OrderEntity(
              id: doc.id,
              customerName: data['customerName'] ?? '',
              customerPhone: data['customerPhone'] ?? '',
              customerAddress: data['location'] ?? '',
              latitude: data['latitude']?.toDouble(),
              longitude: data['longitude']?.toDouble(),
              status: data['status'] ?? 'Pending',
              estimatedTime: _calculateEstimatedTime(
                (data['createdAt'] as Timestamp).toDate(),
              ),
              products: products,
              totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
              createdAt: (data['createdAt'] as Timestamp).toDate(),
              productImage: products.isNotEmpty ? products[0].imageUrl : null,
              createdBy: data['createdBy'] ?? '',
            );
          }).toList();

      print('Processed ${allOrders.length} orders');

      if (role == 'warehouseEmployee' || role == 'admin') {
        print('Emitting all orders for warehouseEmployee/admin role');
        emit(allOrders);
        allOrdersBackup = allOrders;
      } else {
        final userOrders =
            allOrders.where((order) => order.createdBy == userId).toList();
        print('Emitting ${userOrders.length} orders for user role');
        emit(userOrders);
        allOrdersBackup = userOrders;
      }
    } catch (e, stackTrace) {
      print('Error loading orders: $e');
      print('Stack trace: $stackTrace');
      emit([]);
    }
  }

  void searchOrders(String query) {
    if (query.isEmpty) {
      emit(allOrdersBackup);
      return;
    }

    final filtered =
        allOrdersBackup.where((order) {
          return order.customerName.toLowerCase().contains(query.toLowerCase());
        }).toList();

    emit(filtered);
  }

  void addOrder(OrderEntity order) {
    final updatedOrders = List<OrderEntity>.from(state)..add(order);
    emit(updatedOrders);
    allOrdersBackup = updatedOrders;
  }

  Future<void> confirmOrderPrepared(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'status': 'Prepared'},
      );

    } catch (e) {
      print('Error confirming order prepared: $e');
    }
  }

  Future<void> markOrderNotPrepared(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'status': 'Not Prepared'},
      );
    } catch (e) {
      print('Error marking order not prepared: $e');
    }
  }

  void filterOrdersByStatus(String status) {
    if (status.isEmpty) {
      emit(allOrdersBackup);
      return;
    }
    final filtered =
        allOrdersBackup.where((order) => order.status == status).toList();
    emit(filtered);
  }

  String _calculateEstimatedTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes';
    } else {
      return '${difference.inHours} hours';
    }
  }

  Future<void> postOrderPreparedNotification({
    required String orderId,
    required String customerName,
    required String sendToUserId,
    String? note,
  }) async {
    // Fetch sender's name from users collection
    String? senderName;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      senderName =
          userDoc.data()?['name'] ??
          userDoc.data()?['fullName'] ??
          user.email ??
          'Warehouse Employee';
    } else {
      senderName = 'Warehouse Employee';
    }
    await FirebaseFirestore.instance.collection('notifications').add({
      'body': 'Order for $customerName was prepared',
      if (note != null && note.isNotEmpty) 'note': note,
      'sendTo': sendToUserId,
      'timestamp': FieldValue.serverTimestamp(),
      'title': 'Order was Prepared',
      'createdBy': user?.uid,
      'senderName': senderName,
      'isRead': false,
    });
  }

  Future<void> postQuantityChangedNotification({
    required String orderId,
    required String productName,
    required int newQuantity,
    required String customerName,
  }) async {
    String? senderName;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      senderName =
          userDoc.data()?['name'] ??
          userDoc.data()?['fullName'] ??
          user.email ??
          'Sales Representative';
    } else {
      senderName = 'Sales Representative';
    }
    await FirebaseFirestore.instance.collection('notifications').add({
      'body':
          'Quantity for product "$productName" in order for $customerName was changed to $newQuantity.',
      'sendTo': 'warehouseEmployee',
      'timestamp': FieldValue.serverTimestamp(),
      'title': 'Product Quantity Changed',
      'createdBy': user?.uid,
      'senderName': senderName,
      'isRead': false,
      'orderId': orderId,
      'productName': productName,
      'newQuantity': newQuantity,
    });
  }
}
