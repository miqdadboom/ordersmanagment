import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_tasks_front_end/features/products/data/firebase/product_repository.dart';
import 'package:final_tasks_front_end/features/products/presentation/cubit/product_management_cubit.dart';
import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/features/products/presentation/widgets/product_management/product_form_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProductScreen extends StatefulWidget {
  final String documentId;

  const EditProductScreen({super.key, required this.documentId});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  Map<String, dynamic>? productData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductData();
  }

  Future<void> fetchProductData() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.documentId)
            .get();

    if (doc.exists) {
      setState(() {
        productData = doc.data()!..['documentId'] = widget.documentId;
        isLoading = false;
      });
    } else {
      // معالجة حالة عدم وجود المنتج
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Product not found")));
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Product',
          style: TextStyle(color: AppColors.textLight),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : BlocProvider(
                create: (_) => ProductManagementCubit(ProductRepository()),
                child: ProductFormWidget(productData: productData),
              ),
    );
  }
}
