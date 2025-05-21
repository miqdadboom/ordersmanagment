// lib/presentation/screens/list_of_orders_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/bottom_navigation_warehouse_manager.dart';
import '../../data/models/order_model.dart';
import '../../domain/entities/order_product.dart';
import '../widgets/order_card.dart';

class ListOfOrdersScreen extends StatelessWidget {

  const ListOfOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
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
              customerName: data['customerName'] ?? 'Unknown',
              customerAddress: data['location'] ?? 'Unknown',
              latitude: data['latitude'],
              longitude: data['longitude'],
              status: 'Pending',
              estimatedTime: '2 hours',
              products: products,
              productImage: products.isNotEmpty ? products[0].imageUrl : null,
            );
          }).toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildSearchBar(),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'List of incoming orders',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ...orders.map((order) => OrderCard(
                  order: order,
                  onTap: () {
                    if (order.products.isNotEmpty) {
                      _navigateToProducts(context, order.products);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No products available for this order.')),
                      );
                    }
                  },
                )),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavigationWarehouseManager(),
    );
  }

  void _navigateToProducts(BuildContext context, List<OrderProduct> products) {
    Navigator.pushNamed(context, '/products', arguments: products);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF39A18B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'search',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintStyle: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF39A18B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.filter_list),
          ),
        ],
      ),
    );
  }
}
