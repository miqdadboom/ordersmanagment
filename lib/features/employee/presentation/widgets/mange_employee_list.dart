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
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return EmployeeCardWidget(employee: employee);
      },
    );
  }
}
