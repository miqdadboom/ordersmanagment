import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import '../../../products/presentation/widgets/product_management/save_button.dart';
import '../../data/datasources/firebase_employee_service.dart';
import '../../data/models/EmployeeModel.dart';
import '../../data/repositories/employee_repository_impl.dart';
import '../widgets/add_employee_appbar.dart';
import '../widgets/add_employee_text_field.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _distributionController = TextEditingController();
  String _selectedRole = 'employee';
  final Color primaryColor = AppColors.primary;

  final _repo = EmployeeRepositoryImpl(FirebaseEmployeeService());

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final confirm = await _showConfirmationDialog(context, 'Confirm', 'Are you sure?');
      if (!confirm) return;

      final employee = EmployeeModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        distributionLine: _distributionController.text.trim(),
        role: _selectedRole, id: null,
      );

      try {
        await _repo.addEmployee(employee, _passwordController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Employee added successfully"), backgroundColor: Colors.green),
        );
        _clearFields();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _phoneController.clear();
    _addressController.clear();
    _distributionController.clear();
    setState(() => _selectedRole = 'employee');
  }

  Future<bool> _showConfirmationDialog(BuildContext context, String title, String content) async {
    return (await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirm')),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmployeeAppBar(primaryColor: primaryColor),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 66),
                EmployeeTextField(controller: _nameController, hintText: "Name", icon: Icons.person, validatorMessage: "Please enter name", primaryColor: primaryColor),
                EmployeeTextField(controller: _emailController, hintText: "Email", icon: Icons.email, validatorMessage: "Please enter email", primaryColor: primaryColor),
                EmployeeTextField(controller: _passwordController, hintText: "Password", icon: Icons.lock, validatorMessage: "Please enter password", primaryColor: primaryColor),
                EmployeeTextField(controller: _phoneController, hintText: "Phone", icon: Icons.phone, validatorMessage: "Please enter phone", primaryColor: primaryColor),
                EmployeeTextField(controller: _addressController, hintText: "Address", icon: Icons.location_on, validatorMessage: "Please enter address", primaryColor: primaryColor),
                EmployeeTextField(controller: _distributionController, hintText: "Distribution Line", icon: Icons.alt_route, validatorMessage: "Please enter distribution", primaryColor: primaryColor),
                const SizedBox(height: 16),
                _buildRoleDropdown(),
                const SizedBox(height: 55),
                SaveButton(onPressed: () => _submitForm(context), color: primaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      decoration: InputDecoration(
        labelText: 'Select Role',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: const [
        DropdownMenuItem(value: 'employee', child: Text('Sales Representative')),
        DropdownMenuItem(value: 'storekeeper', child: Text('Warehouse Employee')),
      ],
      onChanged: (value) {
        if (value != null) setState(() => _selectedRole = value);
      },
    );
  }
}
