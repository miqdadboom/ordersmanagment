// lib/data/datasources/order_data_source.dart
import '../models/order_model.dart';

abstract class OrderDataSource {
  Future<List<OrderEntity>> getIncomingOrders();
}