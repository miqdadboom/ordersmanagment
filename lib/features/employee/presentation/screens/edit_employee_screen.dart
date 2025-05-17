import 'package:flutter/material.dart';
import '../widgets/edit_employee_form.dart';

class EditEmployee extends StatelessWidget {
  const EditEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: EditEmployeeForm(),
      ),
    );
  }
}
