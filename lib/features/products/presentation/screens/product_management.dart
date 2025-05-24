import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/core/utils/user_access_control.dart';
import 'package:final_tasks_front_end/features/products/presentation/cubit/product_management_cubit.dart';
import '../widgets/product_management/product_form_widget.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
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

    if (!UserAccessControl.ProductManagementScreen(_role!)) {
      return const Scaffold(
        body: Center(child: Text("You are not authorized to access this page.")),
      );
    }

    return BlocProvider(
      create: (context) => ProductManagementCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Product',
            style: TextStyle(color: AppColors.textLight),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const ProductFormWidget(),
      ),
    );
  }
}
