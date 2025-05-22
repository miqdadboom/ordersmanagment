import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/add_employee_appbar.dart';
import '../widgets/add_employee_text_field.dart';
import '../widgets/add_save_button.dart';

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

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final confirm = await _showConfirmationDialog(
        context,
        'Confirm Save',
        'Are you sure you want to save this employee?',
      );

      if (confirm) {
        try {
          final credential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(credential.user!.uid)
              .set({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'address': _addressController.text.trim(),
            'distributionLine': _distributionController.text.trim(),
            'role': _selectedRole,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(' Employee added successfully'),
              backgroundColor: Colors.green,
            ),
          );

          _clearFields();
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(' Error: ${e.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
    setState(() {
      _selectedRole = 'employee';
    });
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(title, style: const TextStyle(color: AppColors.textDark)),
        content:
        Text(content, style: const TextStyle(color: AppColors.textDescription)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.notSelectedItemNavigation)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm', style: TextStyle(color: AppColors.textLight)),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: EmployeeAppBar(primaryColor: primaryColor),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 66),
                EmployeeTextField(
                  controller: _nameController,
                  hintText: "Name",
                  icon: Icons.person,
                  validatorMessage: 'Please enter the name',
                  primaryColor: primaryColor,
                ),
                EmployeeTextField(
                  controller: _emailController,
                  hintText: "Email",
                  icon: Icons.email,
                  validatorMessage: 'Please enter the email',
                  primaryColor: primaryColor,
                ),
                EmployeeTextField(
                  controller: _passwordController,
                  hintText: "Password",
                  icon: Icons.lock,
                  validatorMessage: 'Please enter a password',
                  primaryColor: primaryColor,
                ),
                EmployeeTextField(
                  controller: _phoneController,
                  hintText: "Phone",
                  icon: Icons.phone,
                  validatorMessage: 'Please enter the phone number',
                  primaryColor: primaryColor,
                ),
                EmployeeTextField(
                  controller: _addressController,
                  hintText: "Address",
                  icon: Icons.location_on,
                  validatorMessage: 'Please enter the address',
                  primaryColor: primaryColor,
                ),
                EmployeeTextField(
                  controller: _distributionController,
                  hintText: "Distribution Line",
                  icon: Icons.alt_route,
                  validatorMessage: 'Please enter the distribution line',
                  primaryColor: primaryColor,
                ),
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
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primary.withOpacity(0.4)),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    );

    return DropdownButtonFormField<String>(
      value: _selectedRole,
      decoration: InputDecoration(
        labelText: 'Select Role',
        labelStyle: const TextStyle(color: AppColors.textDark),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
      ),
      items: ['employee', 'storekeeper'].map((role) {
        return DropdownMenuItem<String>(
          value: role,
          child: Text(role[0].toUpperCase() + role.substring(1)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedRole = value;
          });
        }
      },
    );
  }
}
