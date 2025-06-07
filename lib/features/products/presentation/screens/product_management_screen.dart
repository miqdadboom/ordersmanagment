import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/features/products/data/firebase/product_repository.dart';
import 'package:final_tasks_front_end/features/products/presentation/cubit/product_management_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/product_management/product_form_widget.dart';

class ProductManagementScreen extends StatelessWidget {
  final ProductRepository productRepository;

  ProductManagementScreen({super.key, ProductRepository? productRepository})
    : productRepository = productRepository ?? ProductRepository();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => ProductManagementCubit(productRepository),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Product',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const ProductFormWidget(),
      ),
    );
  }
}
