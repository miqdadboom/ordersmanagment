// lib/orders/presentation/screens/order_products_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/user_access_control.dart';
import '../../../../core/widgets/bottom_navigation_warehouse_manager.dart';
import '../../../orders/domain/entities/order_product.dart' as order_product;

class OrderProductsScreen extends StatefulWidget {
  final List<order_product.OrderProduct> products;

  const OrderProductsScreen({super.key, this.products = const []});

  @override
  State<OrderProductsScreen> createState() => _OrderProductsScreenState();
}

class _OrderProductsScreenState extends State<OrderProductsScreen> {
  String? _role;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!UserAccessControl.OrderProductsScreen(_role!)) {
      return const Scaffold(
        body: Center(
          child: Text("You are not authorized to access this page."),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Order Products',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF39A18B),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${widget.products.length} products in this order',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = widget.products[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.shopping_bag,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Quantity: ${product.quantity}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Chip(
                        label: Text(product.passed ? 'Pass' : 'Fail'),
                        backgroundColor:
                            product.passed
                                ? Colors.green[100]
                                : Colors.red[100],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  // TODO: Add your onTap logic here
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF39A18B),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  child: const Text(
                    'Order is prepared',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.45,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
