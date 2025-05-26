// lib/data/datasources/order_data_source_impl.dart
import '../../domain/entities/order_product.dart';
import '../models/order_model.dart';
import 'orders_data_source.dart';

class OrderDataSourceImpl implements OrderDataSource {
  @override
  Future<List<OrderEntity>> getIncomingOrders() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay

    return [
      OrderEntity(
        id: "1",
        customerName: "John Doe",
        customerAddress: "123 Main St",
        estimatedTime: "30 mins",
        status: "unfinished",
        productImage: null,
        latitude: 31.9522,
        longitude: 35.2332,
        createdBy: "sample_sales_user_id",
        products: [
          OrderProduct(
            id: "p1",
            name: "Product A",
            description: "Description A",
            quantity: 2,
            passed: true,
            imageUrl: null,
          ),
        ],
      ),
    ];
  }
}