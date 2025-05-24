import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/user_access_control.dart';
import '../../../../core/widgets/place.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../orders/domain/entities/order_product.dart';
import '../../../orders/presentation/screens/list_of_orders_screen.dart';
import '../widgets/confirm_order_actions.dart';
import '../widgets/confirm_order_fields.dart';
import '../widgets/confirm_order_header.dart';

class ConfirmOrder extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> cartProducts;

  const ConfirmOrder({super.key, required this.cartProducts});

  @override
  ConsumerState<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends ConsumerState<ConfirmOrder> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  PlaceLocation? _selectedLocation;

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

  List<OrderProduct> convertToOrderProducts(List<Map<String, dynamic>> rawProducts) {
    return rawProducts.map((p) {
      return OrderProduct(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: p['title'] ?? 'Unknown',
        description: p['subtitle'] ?? '',
        quantity: p['quantity'] ?? 1,
        passed: true,
        imageUrl: p['imageUrl'],
      );
    }).toList();
  }

  void _savePlace(BuildContext context) {
    FocusScope.of(context).unfocus();
    final customerName = _nameController.text.trim();

    if (_selectedLocation == null || customerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter name and select location')),
      );
      return;
    }

    final convertedProducts = convertToOrderProducts(widget.cartProducts);

    final newOrder = OrderEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: customerName,
      customerAddress: _selectedLocation!.address,
      latitude: _selectedLocation!.latitude,
      longitude: _selectedLocation!.longitude,
      status: 'Pending',
      estimatedTime: '2 hours',
      products: convertedProducts,
      productImage: convertedProducts.isNotEmpty ? widget.cartProducts[0]['imageUrl'] : null,
    );

    final cubit = context.read<OrdersCubit>();
    cubit.addOrder(newOrder);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const ListOfOrdersScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!UserAccessControl.ConfirmOrder(_role!)) {
      return const Scaffold(body: Center(child: Text("You are not authorized to access this page.")));
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: screenHeight * 0.1),
        child: Center(
          child: Container(
            height: screenHeight * 0.85,
            width: screenWidth * 0.9,
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.startConfirmOrder, AppColors.endConfirmOrder],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConfirmOrderHeader(screenWidth: screenWidth),
                ConfirmOrderFields(
                  nameController: _nameController,
                  notesController: _notesController,
                  onLocationSelected: (location) {
                    _selectedLocation = location;
                  },
                ),
                const Spacer(),
                ConfirmOrderActions(
                  onSend: () async {
                    final customerName = _nameController.text.trim();
                    final location = _selectedLocation?.address ?? 'Unknown';

                    if (customerName.isEmpty || _selectedLocation == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter name and select location')),
                      );
                      return;
                    }

                    final products = widget.cartProducts.map((item) => {
                      'title': item['title'] ?? 'Untitled',
                      'price': item['price'] ?? 0,
                      'quantity': item['quantity'] ?? 1,
                      'imageUrl': item['imageUrl'],
                    }).toList();

                    await FirebaseFirestore.instance.collection('orders').add({
                      'customerName': customerName,
                      'location': location,
                      'latitude': _selectedLocation!.latitude,
                      'longitude': _selectedLocation!.longitude,
                      'timestamp': DateTime.now().toIso8601String(),
                      'products': products,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order sent successfully!')),
                    );

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
