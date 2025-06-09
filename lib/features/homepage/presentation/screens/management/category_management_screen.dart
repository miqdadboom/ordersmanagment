import 'package:final_tasks_front_end/features/homepage/presentation/widgets/category_management/category_form.dart';
import 'package:final_tasks_front_end/features/homepage/presentation/widgets/category_management/category_list.dart';
import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/custom_app_bar.dart';

class CategoryManagementScreen extends StatelessWidget {
  const CategoryManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Category Management'),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [CategoryForm(), SizedBox(height: 32), CategoryList()],
        ),
      ),
    );
  }
}
