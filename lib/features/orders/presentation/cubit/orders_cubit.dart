import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/order_model.dart';
import '../../domain/entities/order_product.dart';
import '../../domain/repositories/orders_repository.dart';

class OrdersCubit extends Cubit<List<OrderEntity>> {
  final OrderRepository repository;

  OrdersCubit(this.repository) : super([]);

  Future<void> loadOrderByRole({
    required String role,
    required String userId,
  }) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .get();

    final List<OrderEntity> allOrders = snapshot.docs.map((doc) {
      final data = doc.data();
      final List<OrderProduct> products = (data['products'] as List<dynamic>).map((item) {
        return OrderProduct(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: item['title'] ?? 'Unknown',
          description: '',
          quantity: item['quantity'] ?? 1,
          passed: true,
          imageUrl: item['imageUrl'],
        );
      }).toList();

      return OrderEntity(
        id: doc.id,
        customerName: data['customerName'] ?? '',
        customerAddress: data['location'] ?? '',
        latitude: data['latitude'],
        longitude: data['longitude'],
        status: 'Pending',
        estimatedTime: '2 hours',
        products: products,
        productImage: products.isNotEmpty ? products[0].imageUrl : null,
        createdBy: data['createdBy'] ?? '',
      );
    }).toList();

    if (role == 'warehouse_manager' || role == 'manager') {
      emit(allOrders);
    } else {
      final userOrders = allOrders.where((order) => order.createdBy == userId).toList();
      emit(userOrders);
    }
  }

  void addOrder(OrderEntity order) {
    state.add(order);
    emit(List.from(state));
  }
}
