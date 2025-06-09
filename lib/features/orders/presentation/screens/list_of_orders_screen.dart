import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/user_access_control.dart';
import '../../../../core/widgets/bottom_navigation_manager.dart';
import '../../../../core/widgets/bottom_navigation_sales_representative.dart';
import '../../../../core/widgets/bottom_navigation_warehouse_manager.dart';
import '../../data/models/order_model.dart';
import '../../domain/entities/order_product.dart';
import '../cubit/orders_cubit.dart';
import '../widgets/order_card.dart';
import '../widgets/searchBar.dart';
import '../screens/order_products_screen.dart';

class ListOfOrdersScreen extends StatefulWidget {
  const ListOfOrdersScreen({super.key});

  @override
  State<ListOfOrdersScreen> createState() => _ListOfOrdersScreenState();
}

class _ListOfOrdersScreenState extends State<ListOfOrdersScreen> {
  String? _role;
  bool _loading = true;
  String _selectedStatus = '';
  String _searchQuery = '';
  List<OrderEntity> _allOrders = [];
  List<OrderEntity> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _getUserRoleAndLoadOrders();
  }

  Future<void> _getUserRoleAndLoadOrders() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final role = doc['role'];

    if (!mounted) return;

    setState(() {
      _role = role;
      _loading = false;
    });

    context.read<OrdersCubit>().loadOrderByRole(role: role, userId: userId);
  }

  void _searchOrders(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _filterOrdersByStatus(String status) {
    setState(() {
      _selectedStatus = status;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<OrderEntity> filtered = _allOrders;
    if (_selectedStatus.isNotEmpty) {
      filtered =
          filtered.where((order) => order.status == _selectedStatus).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (order) => order.customerName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();
    }
    _filteredOrders = filtered;
  }

  Widget? _buildBottomNavigationBar() {
    final normalizedRole = UserAccessControl.normalizeRole(_role);
    if (normalizedRole == 'admin') {
      return const BottomNavigationManager();
    } else if (normalizedRole == 'salesRepresentative') {
      return const BottomNavigationSalesRepresentative();
    } else if (normalizedRole == 'warehouseEmployee') {
      return const BottomNavigationWarehouseManager();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final normalizedRole = UserAccessControl.normalizeRole(_role);
    if (!UserAccessControl.ListOfOrdersScreen(normalizedRole)) {
      return const Scaffold(
        body: Center(
          child: Text("You are not authorized to access this page."),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          'Orders',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          buildSearchBar(
            context,
            onSearch: _searchOrders,
            onFilter: _filterOrdersByStatus,
            selectedStatus: _selectedStatus,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'List of incoming orders',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('orders').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                final List<OrderEntity> allOrders =
                    docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final List<OrderProduct> products =
                          (data['products'] as List<dynamic>).map((item) {
                            return OrderProduct(
                              id:
                                  DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                              name: item['title'] ?? 'Unknown',
                              description: '',
                              quantity: item['quantity'] ?? 1,
                              passed: item['passed'],
                              imageUrl: item['imageUrl'] ?? '',
                            );
                          }).toList();
                      return OrderEntity(
                        id: doc.id,
                        customerName: data['customerName'] ?? '',
                        customerPhone: data['customerPhone'] ?? '',
                        customerAddress: data['location'] ?? '',
                        latitude: data['latitude']?.toDouble(),
                        longitude: data['longitude']?.toDouble(),
                        status: data['status'] ?? 'Pending',
                        estimatedTime: _calculateEstimatedTime(
                          (data['createdAt'] is Timestamp)
                              ? (data['createdAt'] as Timestamp).toDate()
                              : DateTime.now(),
                        ),
                        products: products,
                        totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
                        createdAt:
                            (data['createdAt'] is Timestamp)
                                ? (data['createdAt'] as Timestamp).toDate()
                                : DateTime.now(),
                        productImage:
                            products.isNotEmpty ? products[0].imageUrl : null,
                        createdBy: data['createdBy'] ?? '',
                      );
                    }).toList();
                // Apply role-based filtering
                final userId = FirebaseAuth.instance.currentUser!.uid;
                final normalizedRole = UserAccessControl.normalizeRole(_role);
                List<OrderEntity> filteredOrders;
                if (normalizedRole == 'warehouseEmployee' ||
                    normalizedRole == 'admin') {
                  filteredOrders = allOrders;
                } else {
                  filteredOrders =
                      allOrders
                          .where((order) => order.createdBy == userId)
                          .toList();
                }
                // Save allOrders for search/filter
                _allOrders = filteredOrders;
                _applyFilters();
                if (_filteredOrders.isEmpty) {
                  return const Center(child: Text('No orders found.'));
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._filteredOrders.map(
                        (order) => GestureDetector(
                          onLongPress: () {
                            if (_role == 'salesRepresentative') {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Delete Order'),
                                      content: const Text(
                                        'Are you sure you want to delete this order?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('orders')
                                                .doc(order.id)
                                                .delete();
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                              );
                            }
                          },
                          child: OrderCard(
                            order: order,
                            onTap: () {
                              if (order.products.isNotEmpty) {
                                _navigateToProducts(
                                  context,
                                  order.products,
                                  order,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'No products available for this order.',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 60,
          child: _buildBottomNavigationBar() ?? const SizedBox(),
        ),
      ),
    );
  }

  void _navigateToProducts(
    BuildContext context,
    List<OrderProduct> products,
    OrderEntity order,
  ) {
    Navigator.pushNamed(
      context,
      '/products',
      arguments: {'products': products, 'orderId': order.id},
    );
  }

  Future<void> _updateOrderStatusIfNeeded(String orderId) async {
    final orderRef = FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId);
    final orderDoc = await orderRef.get();
    final List<dynamic> products = orderDoc.data()?['products'] ?? [];

    bool allSet = products.every((p) => p['passed'] != null);
    if (!allSet) {
      await orderRef.update({'status': 'Pending'});
      return;
    }

    bool allPassed = products.every((p) => p['passed'] == true);
    if (allPassed) {
      await orderRef.update({'status': 'Passed'});
      return;
    }

    bool anyFailed = products.any((p) => p['passed'] == false);
    if (anyFailed) {
      await orderRef.update({'status': 'Failed'});
      return;
    }
  }

  Future<void> _updateProductStatus(
    OrderProduct product,
    bool? newStatus,
    String orderId,
  ) async {
    // ... your existing code to update the product's status in Firestore ...

    // After updating the product's status:
    await _updateOrderStatusIfNeeded(orderId);
  }

  String _calculateEstimatedTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return '${difference.inHours} hours ago';
    }
  }
}
