import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/EmployeeModel.dart';
import '../../data/repositories/employee_repository_impl.dart';
import '../../data/datasources/firebase_employee_service.dart';
import '../widgets/edit_employee_textfield.dart';
import '../widgets/add_save_button.dart';

class EditEmployeeForm extends StatefulWidget {
  final String userId;

  const EditEmployeeForm({super.key, required this.userId});

  @override
  State<EditEmployeeForm> createState() => _EditEmployeeFormState();
}

class _EditEmployeeFormState extends State<EditEmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _distributionController = TextEditingController();
  String? _selectedRole;

  bool _loading = true;
  bool _isSaving = false;
  final _repo = EmployeeRepositoryImpl(FirebaseEmployeeService());
  EmployeeModel? _employee;

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

  Future<void> _loadEmployeeData() async {
    try {
      final employee = await _repo.getEmployeeById(widget.userId);
      if (employee != null) {
        _employee = employee;
        _nameController.text = employee.name;
        _emailController.text = employee.email;
        _phoneController.text = employee.phone;
        _addressController.text = employee.address;
        _distributionController.text = employee.distributionLine;
        _selectedRole = employee.role;
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Employee not found")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading employee: \$e")),
      );
      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _updateEmployee() async {
    if (_formKey.currentState!.validate() && _employee != null) {
      final updated = EmployeeModel(
        id: _employee!.id,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        distributionLine: _distributionController.text.trim(),
        role: _selectedRole!,
      );

      try {
        setState(() => _isSaving = true);
        await _repo.updateEmployee(updated);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Employee updated successfully"),
            backgroundColor: AppColors.success,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Update failed: \$e"),
            backgroundColor: AppColors.error,
          ),
        );
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deleteEmployee() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Employee"),
        content: const Text("Are you sure you want to delete this employee?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.iconDelete),
            child: const Text("Delete"),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _repo.deleteEmployee(widget.userId);
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Employee deleted"),
            backgroundColor: AppColors.success,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Delete failed: \$e"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _buildRoleDropdown() {
    const validRoles = [
      'admin',
      'sales representative',
      'warehouse employee',
    ];

    return DropdownButtonFormField<String>(
      value: validRoles.contains(_selectedRole) ? _selectedRole : null,
      decoration: InputDecoration(
        labelText: 'Select Role',
        labelStyle: AppTextStyles.bodySuggestion(context),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.4)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      dropdownColor: AppColors.background,
      items: const [
        DropdownMenuItem(
          value: 'admin',
          child: Text('Admin'),
        ),
        DropdownMenuItem(
          value: 'sales representative',
          child: Text('Sales Representative'),
        ),
        DropdownMenuItem(
          value: 'warehouse employee',
          child: Text('Warehouse Employee'),
        ),
      ],
      onChanged: (value) {
        if (mounted) setState(() => _selectedRole = value);
      },
      validator: (value) => value == null ? 'Please select a role' : null,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _distributionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Edit Employee",
                style: AppTextStyles.dialogTitle(context),
              ),
            ),
            const SizedBox(height: 20),
            EditEmployeeTextField(
              controller: _nameController,
              label: "Name",
              icon: Icons.person,
              validatorMessage: 'Please enter the name',
            ),
            EditEmployeeTextField(
              controller: _emailController,
              label: "Email",
              icon: Icons.email,
              validatorMessage: 'Please enter the email',
            ),
            EditEmployeeTextField(
              controller: _phoneController,
              label: "Phone",
              icon: Icons.phone,
              validatorMessage: 'Please enter the phone number',
            ),
            EditEmployeeTextField(
              controller: _addressController,
              label: "Address",
              icon: Icons.location_on,
              validatorMessage: 'Please enter the address',
            ),
            EditEmployeeTextField(
              controller: _distributionController,
              label: "Distribution Line",
              icon: Icons.route,
              validatorMessage: 'Please enter the distribution line',
            ),
            _buildRoleDropdown(),
            const SizedBox(height: 30),
            SaveButton(
              onPressed: _isSaving
                  ? null
                  : () {
                FocusScope.of(context).unfocus();
                _formKey.currentState!.validate()
                    ? _updateEmployee()
                    : null;
              },
              isLoading: _isSaving,
              color: AppColors.primary,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _deleteEmployee,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.iconDelete,
                ),
                child: Text(
                  "Delete",
                  style: AppTextStyles.dialogDeleteButton(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
