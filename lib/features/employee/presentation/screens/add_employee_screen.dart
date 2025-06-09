import 'package:final_tasks_front_end/core/constants/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/core/constants/app_text_styles.dart';
import '../../../../core/constants/app_size_box.dart';
import '../../../../core/utils/app_exception.dart';
import '../../data/datasources/firebase_employee_service.dart';
import '../../data/models/EmployeeModel.dart';
import '../../data/repositories/employee_repository_impl.dart';
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
  String? _selectedRole;
  bool _isLoading = false;

  final Color primaryColor = AppColors.primary;
  final _repo = EmployeeRepositoryImpl(FirebaseEmployeeService());

  Future<void> _submitForm(BuildContext context) async {
    if (_isLoading) return;

    if (_formKey.currentState!.validate() && _selectedRole != null) {
      final confirm = await _showConfirmationDialog(context, 'Confirm', 'Are you sure?');
      if (!confirm) return;

      final employee = EmployeeModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        distributionLine: _distributionController.text.trim(),
        role: _selectedRole!,
        id: null,
      );

      try {
        setState(() => _isLoading = true);

        await _repo.addEmployee(employee, _passwordController.text.trim());

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Employee added successfully",
              style: AppTextStyles.bodyLight(context),
            ),
            backgroundColor: AppColors.success,
          ),
        );
        _clearFields();
      } on FirebaseException catch (e) {
        if (!mounted) return;
        String message;
        if (e.code == 'network-request-failed') {
          message = NoInternetException().message;
        } else {
          message = ServerException(e.message ?? "Server error").message;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: AppTextStyles.bodyLight(context)),
            backgroundColor: AppColors.error,
          ),
        );
      } on AppException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message, style: AppTextStyles.bodyLight(context)),
            backgroundColor: AppColors.error,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Unexpected error: $e", style: AppTextStyles.bodyLight(context)),
            backgroundColor: AppColors.error,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else if (_selectedRole == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select a role", style: AppTextStyles.bodyLight(context)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _phoneController.clear();
    _addressController.clear();
    _distributionController.clear();
    setState(() => _selectedRole = null);
  }

  Future<bool> _showConfirmationDialog(BuildContext context, String title, String content) async {
    return (await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: AppTextStyles.dialogTitle(context)),
        content: Text(content, style: AppTextStyles.bodySuggestion(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: AppTextStyles.dialogCancelButton(context)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirm', style: AppTextStyles.dialogButton(context)),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Add Employee"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppSizedBox.height(context, 0.08),
                EmployeeTextField(controller: _nameController, hintText: "Name", icon: Icons.person, validatorMessage: "Please enter name", primaryColor: primaryColor),
                EmployeeTextField(controller: _emailController, hintText: "Email", icon: Icons.email, validatorMessage: "Please enter email", primaryColor: primaryColor),
                EmployeeTextField(controller: _passwordController, hintText: "Password", icon: Icons.lock, validatorMessage: "Please enter password", primaryColor: primaryColor),
                EmployeeTextField(controller: _phoneController, hintText: "Phone", icon: Icons.phone, validatorMessage: "Please enter phone", primaryColor: primaryColor),
                EmployeeTextField(controller: _addressController, hintText: "Address", icon: Icons.location_on, validatorMessage: "Please enter address", primaryColor: primaryColor),
                EmployeeTextField(controller: _distributionController, hintText: "Distribution Line", icon: Icons.alt_route, validatorMessage: "Please enter distribution", primaryColor: primaryColor),
                AppSizedBox.height(context, 0.02),
                _buildRoleDropdown(context),
                AppSizedBox.height(context, 0.07),
                SaveButton(
                  onPressed: _isLoading ? null : () => _submitForm(context),
                  color: primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      decoration: InputDecoration(
        labelText: 'Select Role',
        labelStyle: AppTextStyles.bodySuggestion(context),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: [
        DropdownMenuItem(
          value: 'salesRepresentative',
          child: Text('Sales Representative', style: AppTextStyles.bodySuggestion(context)),
        ),
        DropdownMenuItem(
          value: 'warehouseEmployee',
          child: Text('Warehouse Employee', style: AppTextStyles.bodySuggestion(context)),
        ),
      ],
      onChanged: (value) {
        setState(() => _selectedRole = value);
      },
      validator: (value) => value == null ? 'Please select a role' : null,
    );
  }
}