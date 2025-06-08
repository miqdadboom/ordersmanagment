import 'package:cloud_firestore/cloud_firestore.dart';
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
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Orders', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
            final String customerName = data['customerName'] ?? 'Unknown';

            final List<OrderProduct> products = (data['products'] as List<dynamic>).map((item) {
              return OrderProduct(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: item['title'] ?? 'Unknown',
                description: '',
                quantity: item['quantity'] ?? 1,
                passed: true,
                imageUrl: item['imageUrl'],
                customerName: customerName, // assign the name here
              );
            }).toList();

            return OrderEntity(
              id: doc.id,
              customerName: customerName,
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
                      _navigateToProducts(context, order); // Pass full order here
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

  void _navigateToProducts(BuildContext context, OrderEntity order) {
    Navigator.pushNamed(
      context,
      '/products',
      arguments: {
        'products': order.products,
        'customerName': order.customerName,
      },
    );
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
