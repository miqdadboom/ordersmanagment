import 'package:flutter/material.dart';
import 'mange_employee_card.dart';

class EmployeeListWidget extends StatelessWidget {
  final List<Map<String, String>> employees;

  const EmployeeListWidget({
    super.key,
    required this.employees,
  });

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) {
      return const Center(
        child: Text(
          "No employees found.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: EmployeeCardWidget(employee: employee),
        );
      },
    );
  }
}
