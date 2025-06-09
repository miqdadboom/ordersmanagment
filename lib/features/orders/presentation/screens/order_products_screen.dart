// lib/orders/presentation/screens/order_products_screen.dart
import 'package:final_tasks_front_end/core/constants/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/user_access_control.dart';
import '../../../../core/widgets/bottom_navigation_warehouse_manager.dart';
import '../../domain/entities/order_product.dart' as order_product;
import '../../../confirm_order/presentation/screens/confirm_order.dart';
import '../widgets/confirm_prepareOrder.dart';
import '../cubit/orders_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderProductsScreen extends StatefulWidget {
  final List<order_product.OrderProduct> products;
  final String orderId;

  const OrderProductsScreen({
    super.key,
    this.products = const [],
    required this.orderId,
  });

  @override
  State<OrderProductsScreen> createState() => _OrderProductsScreenState();
}

class _OrderProductsScreenState extends State<OrderProductsScreen> {
  String? _role;
  bool _loading = true;
  late List<order_product.OrderProduct> _products;

  @override
  void initState() {
    super.initState();
    _products = List.from(widget.products);
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
      final role = doc.data()?['role'];
      if (!mounted) return;
      setState(() {
        _role = role;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
      // Optionally show an error message
    }
  }

  Future<void> _updateProductStatus(int index, bool? newStatus) async {
    final product = _products[index];
    final orderRef = FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId);
    final orderDoc = await orderRef.get();
    final List<dynamic> currentProducts = orderDoc.data()?['products'] ?? [];
    final updatedProducts =
        currentProducts.map((item) {
          if (item['title'] == product.name) {
            return {...item, 'passed': newStatus};
          }
          return item;
        }).toList();
    await orderRef.update({'products': updatedProducts});
    setState(() {
      _products[index] = order_product.OrderProduct(
        id: product.id,
        name: product.name,
        description: product.description,
        quantity: product.quantity,
        passed: newStatus,
        imageUrl: product.imageUrl,
      );
    });
    await _updateOrderStatusIfNeeded();
    await BlocProvider.of<OrdersCubit>(context).loadOrderByRole(
      role: _role!,
      userId: FirebaseAuth.instance.currentUser!.uid,
    );
  }

  Future<void> _updateOrderStatusIfNeeded() async {
    final orderRef = FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId);
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
      appBar: CustomAppBar(title: "Order Products"),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('orders')
                    .doc(widget.orderId)
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox(height: 56); // Placeholder height
              }
              final data = snapshot.data!.data() as Map<String, dynamic>?;
              final List<dynamic> products = data?['products'] ?? [];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${products.length} products in this order',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('orders')
                      .doc(widget.orderId)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final data = snapshot.data!.data() as Map<String, dynamic>?;
                final List<dynamic> products = data?['products'] ?? [];
                if (products.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = products[index];
                    return GestureDetector(
                      onTap: () async {
                        if (_role == 'warehouseEmployee') {
                          // Toggle Pass/Fail status for this product
                          final orderRef = FirebaseFirestore.instance
                              .collection('orders')
                              .doc(widget.orderId);
                          final List<dynamic> currentProducts = List.from(
                            products,
                          );
                          final updatedProducts =
                              currentProducts.map((p) {
                                if (p['title'] == item['title']) {
                                  return {
                                    ...p,
                                    'passed':
                                        p['passed'] == true ? false : true,
                                  };
                                }
                                return p;
                              }).toList();
                          await orderRef.update({'products': updatedProducts});
                          // Update order status after product status change
                          final refreshedDoc = await orderRef.get();
                          final List<dynamic> refreshedProducts =
                              refreshedDoc.data()?['products'] ?? [];
                          bool allSet =
                              refreshedProducts.isNotEmpty &&
                              refreshedProducts.every(
                                (p) => p['passed'] != null,
                              );
                          if (!allSet) {
                            await orderRef.update({'status': 'Pending'});
                          } else {
                            bool allPassed = refreshedProducts.every(
                              (p) => p['passed'] == true,
                            );
                            if (allPassed) {
                              await orderRef.update({'status': 'Passed'});
                            } else if (refreshedProducts.any(
                              (p) => p['passed'] == false,
                            )) {
                              await orderRef.update({'status': 'Failed'});
                            }
                          }
                        }
                      },
                      onLongPress: () {
                        if (_role == 'salesRepresentative') {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Delete Product'),
                                  content: Text(
                                    'Are you sure you want to delete this product (${item['title']})?',
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
                                        final orderRef = FirebaseFirestore
                                            .instance
                                            .collection('orders')
                                            .doc(widget.orderId);
                                        final List<dynamic> currentProducts =
                                            products;
                                        final updatedProducts =
                                            currentProducts
                                                .where(
                                                  (p) =>
                                                      p['title'] !=
                                                      item['title'],
                                                )
                                                .toList();
                                        await orderRef.update({
                                          'products': updatedProducts,
                                        });
                                        Navigator.of(context).pop();
                                        // If all products are deleted, delete the order and return to Orders page
                                        if (updatedProducts.isEmpty) {
                                          await orderRef.delete();
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                                try {
                                                  Navigator.of(
                                                    context,
                                                  ).popUntil(
                                                    (route) => route.isFirst,
                                                  );
                                                } catch (_) {}
                                              });
                                        } else {
                                          // Recalculate order status if products remain
                                          bool allSet =
                                              updatedProducts.isNotEmpty &&
                                              updatedProducts.every(
                                                (p) => p['passed'] != null,
                                              );
                                          if (!allSet) {
                                            await orderRef.update({
                                              'status': 'Pending',
                                            });
                                          } else {
                                            bool allPassed = updatedProducts
                                                .every(
                                                  (p) => p['passed'] == true,
                                                );
                                            if (allPassed) {
                                              await orderRef.update({
                                                'status': 'Passed',
                                              });
                                            } else if (updatedProducts.any(
                                              (p) => p['passed'] == false,
                                            )) {
                                              await orderRef.update({
                                                'status': 'Failed',
                                              });
                                            }
                                          }
                                        }
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                          );
                        }
                      },
                      child: Container(
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
                              child:
                                  item['imageUrl'] != null &&
                                          item['imageUrl'] != ''
                                      ? Image.network(
                                        item['imageUrl'],
                                        fit: BoxFit.cover,
                                      )
                                      : const Icon(
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
                                    item['title'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () async {
                                      if (_role == 'salesRepresentative') {
                                        final controller =
                                            TextEditingController(
                                              text:
                                                  (item['quantity'] ?? 0)
                                                      .toString(),
                                            );
                                        final result = await showDialog<String>(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text(
                                                  'Edit Quantity',
                                                ),
                                                content: TextField(
                                                  controller: controller,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                        labelText: 'Quantity',
                                                      ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.of(
                                                          context,
                                                        ).pop(controller.text),
                                                    child: const Text('Save'),
                                                  ),
                                                ],
                                              ),
                                        );
                                        if (result != null &&
                                            int.tryParse(result) != null) {
                                          final newQuantity = int.parse(result);
                                          if (newQuantity !=
                                              (item['quantity'] ?? 0)) {
                                            try {
                                              final orderRef = FirebaseFirestore
                                                  .instance
                                                  .collection('orders')
                                                  .doc(widget.orderId);
                                              final List<dynamic>
                                              currentProducts = List.from(
                                                products,
                                              );
                                              final updatedProducts =
                                                  currentProducts.map((p) {
                                                    if (p['title'] ==
                                                        item['title']) {
                                                      return {
                                                        ...p,
                                                        'quantity': newQuantity,
                                                      };
                                                    }
                                                    return p;
                                                  }).toList();
                                              await orderRef.update({
                                                'products': updatedProducts,
                                              });
                                              // Send notification to warehouse employees
                                              final orderDoc =
                                                  await orderRef.get();
                                              final orderData =
                                                  orderDoc.data()
                                                      as Map<String, dynamic>?;
                                              final customerName =
                                                  orderData != null
                                                      ? (orderData['customerName'] ??
                                                          '')
                                                      : '';
                                              await BlocProvider.of<
                                                OrdersCubit
                                              >(
                                                context,
                                              ).postQuantityChangedNotification(
                                                orderId: widget.orderId,
                                                productName:
                                                    item['title'] ?? '',
                                                newQuantity: newQuantity,
                                                customerName: customerName,
                                              );
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Failed to update quantity: $e',
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Quantity: ${item['quantity'] ?? 0}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            _role == 'salesRepresentative'
                                                ? Colors.blue
                                                : Colors.black54,
                                        decoration:
                                            _role == 'salesRepresentative'
                                                ? TextDecoration.underline
                                                : null,
                                        fontWeight:
                                            _role == 'salesRepresentative'
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Chip(
                              label: Text(
                                (item['passed'] == true) ? 'Pass' : 'Fail',
                              ),
                              backgroundColor:
                                  (item['passed'] == true)
                                      ? Colors.green[100]
                                      : Colors.red[100],
                              labelStyle: TextStyle(
                                color:
                                    (item['passed'] == true)
                                        ? Colors.green[800]
                                        : Colors.red[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (_role == 'warehouseEmployee')
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 21),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF39A18B),
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                  elevation: 6,
                ),
                onPressed: () async {
                  final TextEditingController noteController =
                      TextEditingController();
                  await showDialog(
                    context: context,
                    builder:
                        (context) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: CustomStyledContainer(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'Is the order prepared?',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: TextField(
                                    controller: noteController,
                                    decoration: const InputDecoration(
                                      labelText: 'Note (optional)',
                                      border: OutlineInputBorder(),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                    minLines: 1,
                                    maxLines: 3,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () async {
                                        // Fetch order details for notification
                                        final orderDoc =
                                            await FirebaseFirestore.instance
                                                .collection('orders')
                                                .doc(widget.orderId)
                                                .get();
                                        final orderData = orderDoc.data();
                                        final customerName =
                                            orderData != null
                                                ? (orderData['customerName'] ??
                                                    '')
                                                : '';
                                        final sendToUserId =
                                            orderData != null
                                                ? (orderData['createdBy'] ?? '')
                                                : '';
                                        final note = noteController.text;
                                        await BlocProvider.of<OrdersCubit>(
                                          context,
                                        ).confirmOrderPrepared(widget.orderId);
                                        // Post notification
                                        await BlocProvider.of<OrdersCubit>(
                                          context,
                                        ).postOrderPreparedNotification(
                                          orderId: widget.orderId,
                                          customerName: customerName,
                                          sendToUserId: sendToUserId,
                                          note: note,
                                        );
                                        Navigator.of(context).pop();
                                        await BlocProvider.of<OrdersCubit>(
                                          context,
                                        ).loadOrderByRole(
                                          role: _role!,
                                          userId:
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid,
                                        );
                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Order marked as prepared successfully!',
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () async {
                                        await BlocProvider.of<OrdersCubit>(
                                          context,
                                        ).markOrderNotPrepared(widget.orderId);
                                        Navigator.of(context).pop();
                                        await BlocProvider.of<OrdersCubit>(
                                          context,
                                        ).loadOrderByRole(
                                          role: _role!,
                                          userId:
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid,
                                        );
                                      },
                                      child: const Text('Not Yet'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                  );
                },
                child: const Text(
                  'Order is prepared',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
