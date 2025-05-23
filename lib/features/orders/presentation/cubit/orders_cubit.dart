// lib/presentation/cubit/orders_cubit.dart
import 'package:bloc/bloc.dart';

import '../../data/models/order_model.dart';
import '../../domain/repositories/orders_repository.dart';

class OrdersCubit extends Cubit<List<OrderEntity>> {
  final OrderRepository repository;
  OrdersCubit(this.repository) : super([]);

  Future<void> loadOrders() async {
    final orders = await repository.getIncomingOrders();
    emit(orders);
  }

  void addOrder(OrderEntity order) {
    state.add(order);
    emit(List.from(state)); // Force rebuild
  }
}