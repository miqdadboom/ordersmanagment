import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/user_access_control.dart';
import '../../../../core/widgets/bottom_navigation_warehouse_manager.dart';
import '../../data/models/order_model.dart';
import '../../domain/entities/order_product.dart';
import '../cubit/orders_cubit.dart';
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
    _getUserRoleAndLoadOrders();
  }

  Future<void> _getUserRoleAndLoadOrders() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final role = doc['role'];

    if (!mounted) return;

    setState(() {
      _role = role;
      _loading = false;
    });

    context.read<OrdersCubit>().loadOrderByRole(role: role, userId: userId);
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
        title: const Text('Orders', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<OrdersCubit, List<OrderEntity>>(
        builder: (context, orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildSearchBar(),
                const Padding(
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
