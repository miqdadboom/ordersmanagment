import 'package:final_tasks_front_end/features/homepage/data/firebase/product_repository.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/cubit/product_management_cubit.dart';
import 'package:flutter/material.dart';
import '../../widgets/product_management/product_form_widget.dart';
import 'package:final_tasks_front_end/core/constants/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        appBar: CustomAppBar(title: 'Add Product', showBackButton: true),
        body: Column(children: [const Expanded(child: ProductFormWidget())]),
      ),
    );
  }
}
