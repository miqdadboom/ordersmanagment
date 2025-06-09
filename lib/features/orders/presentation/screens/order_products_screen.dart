import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/order_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderProductsScreen extends StatefulWidget {
  final List<OrderProduct> products;
  final String orderId;

  const OrderProductsScreen({
    Key? key,
    required this.products,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderProductsScreen> createState() => _OrderProductsScreenState();
}

class _OrderProductsScreenState extends State<OrderProductsScreen> {
  late List<OrderProduct> products;
  late String orderId;

  @override
  void initState() {
    super.initState();
    products = List.from(widget.products);
    orderId = widget.orderId;
  }

  Future<void> _updateProductStatus(
      OrderProduct product,
      bool? newStatus,
      ) async {
    try {
      final orderRef = FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId);
      final orderDoc = await orderRef.get();

      if (!orderDoc.exists) {
        throw Exception('Order not found');
      }

      final List<dynamic> currentProducts = orderDoc.data()?['products'] ?? [];
      final updatedProducts =
      currentProducts.map((item) {
        if (item['title'] == product.name) {
          return {...item, 'passed': newStatus};
        }
        return item;
      }).toList();

      await orderRef.update({'products': updatedProducts});

      // Update local state
      setState(() {
        final index = products.indexWhere((p) => p.name == product.name);
        if (index != -1) {
          products[index] = OrderProduct(
            id: product.id,
            name: product.name,
            description: product.description,
            quantity: product.quantity,
            passed: newStatus,
            imageUrl: product.imageUrl,
          );
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product status updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update product status: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          'Order Products',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _ProductCard(
            product: product,
            onStatusChanged: (bool? status) {
              _updateProductStatus(product, status);
            },
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final OrderProduct product;
  final Function(bool?) onStatusChanged;

  const _ProductCard({
    Key? key,
    required this.product,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            leading:
            widget.product.imageUrl.isNotEmpty
                ? Image.network(
              widget.product.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported);
              },
            )
                : const Icon(Icons.image_not_supported),
            title: Text(widget.product.name),
            subtitle: Text('Quantity: ${widget.product.quantity}'),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStatusButton(true, 'Pass'),
                      const SizedBox(width: 8),
                      _buildStatusButton(false, 'Failed'),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(bool? status, String label) {
    final isSelected = widget.product.passed == status;
    final color =
    status == true
        ? Colors.green
        : status == false
        ? Colors.orange
        : Colors.grey;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: () => widget.onStatusChanged(status),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? color : color.withOpacity(0.1),
            foregroundColor: isSelected ? Colors.white : color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: color),
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
