// lib/domain/repositories/order_repository.dart
import '../../data/models/order_model.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getIncomingOrders();
}