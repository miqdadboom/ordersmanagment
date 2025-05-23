// lib/orders/data/repositories/orders_repository_impl.dart
import '../../data/datasources/orders_data_source.dart';
import '../../data/models/order_model.dart';
import '../../domain/repositories/orders_repository.dart';
import '../../presentation/cubit/orders_cubit.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource dataSource;

  OrderRepositoryImpl({required this.dataSource});

  @override
  Future<List<OrderEntity>> getIncomingOrders() {
    return dataSource.getIncomingOrders();
  }
}