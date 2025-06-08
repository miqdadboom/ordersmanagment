import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/EmployeeModel.dart';
import 'mange_employee_card.dart';

class EmployeeListWidget extends StatelessWidget {
  final List<EmployeeModel> employees;

  const EmployeeListWidget({
    super.key,
    required this.employees,
  });

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) {
      return Center(
        child: Text(
          "No employees found.",
          style: AppTextStyles.bodySuggestion(context).copyWith(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      itemCount: employees.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: EmployeeCardWidget(employee: employees[index]),
        );
      },
    );
  }
}
