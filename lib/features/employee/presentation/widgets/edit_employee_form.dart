import 'package:flutter/material.dart';
import 'edit_employee_textfield.dart';

class EditEmployeeForm extends StatefulWidget {
  const EditEmployeeForm({super.key});

  @override
  State<EditEmployeeForm> createState() => _EditEmployeeFormState();
}

class _EditEmployeeFormState extends State<EditEmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _distributionController = TextEditingController();

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final job = _jobController.text;
      print('The employee has been saved: $name - $job');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The employee has been saved successfully')),
      );

      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _jobController.clear();
      _addressController.clear();
      _distributionController.clear();
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this employee?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("The employee has been deleted")),
                );
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Edit Employee Details",
                style: TextStyle(
                  height: 5,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF39A28B),
                ),
              ),
            ),
            const SizedBox(height: 5),
            EditEmployeeTextField(controller: _nameController, label: "Person", icon: Icons.person, validatorMessage: 'Please enter the name'),
            EditEmployeeTextField(controller: _emailController, label: "Email", icon: Icons.email, validatorMessage: 'Please enter the email'),
            EditEmployeeTextField(controller: _phoneController, label: "Phone", icon: Icons.phone, validatorMessage: 'Please enter the phone number'),
            EditEmployeeTextField(controller: _jobController, label: "Job", icon: Icons.work, validatorMessage: 'Please enter the job title'),
            EditEmployeeTextField(controller: _addressController, label: "Address", icon: Icons.location_on, validatorMessage: 'Please enter the address'),
            EditEmployeeTextField(controller: _distributionController, label: "Distribution Line", icon: Icons.straight_outlined, validatorMessage: 'Please enter the distribution line'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _submitForm(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Color(0xFF39A28B),
                ),
                child: const Text('Save', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _confirmDelete(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.red,
                ),
                child: const Text('Delete Employee', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
