import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/features/products/presentation/cubit/product_management_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/product_management/product_form_widget.dart';

class ProductManagementScreen extends StatelessWidget {
  const ProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const ProductFormWidget(),
      ),
    );
  }
}
