// lib/presentation/screens/list_of_orders_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/user_access_control.dart';
import '../../../../core/widgets/bottom_navigation_warehouse_manager.dart';
import '../../data/models/order_model.dart';
import '../../domain/entities/order_product.dart';
import '../widgets/order_card.dart';

class ListOfOrdersScreen extends StatefulWidget {
  const ListOfOrdersScreen({super.key});

  @override
  State<ListOfOrdersScreen> createState() => _ListOfOrdersScreenState();
}

class _ListOfOrdersScreenState extends State<ListOfOrdersScreen> {
  String? _role;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final role = doc['role'];

    if (!mounted) return;
    setState(() {
      _role = role;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!UserAccessControl.ListOfOrdersScreen(_role!)) {

      return const Scaffold(
        body: Center(child: Text("You are not authorized to access this page.")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title:  Text('Orders', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
        automaticallyImplyLeading: false,
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
                 Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'List of incoming orders',
                    style: TextStyle(
                      color: AppColors.textDark,
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
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.border,
                  width: 1.5,
                ),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'search',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintStyle: TextStyle(color: AppColors.textDark, fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.border,
                width: 1.5,
              ),
            ),
            child: const Icon(Icons.filter_list),
          ),
        ],
      ),
    );
  }
}
