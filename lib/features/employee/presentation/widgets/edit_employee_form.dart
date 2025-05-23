import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_colors.dart';
import 'edit_employee_textfield.dart';

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

  String _selectedRole = 'sales representative';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

  Future<void> _loadEmployeeData() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
    final data = doc.data();
    if (data != null) {
      _nameController.text = data['name'] ?? '';
      _emailController.text = data['email'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _addressController.text = data['address'] ?? '';
      _distributionController.text = data['distributionLine'] ?? '';
      _selectedRole = data['role'] ?? 'sales representative';
    }

    if (!mounted) return;
    setState(() {
      _loading = false;
    });
  }

  Future<void> _updateEmployee() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'distributionLine': _distributionController.text.trim(),
        'role': _selectedRole,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Employee updated successfully")),
      );
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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.deleteButton),
            child: const Text("Delete"),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).delete();
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Employee deleted")),
      );
    }
  }

  Widget _buildRoleDropdown() {
    final validRoles = [
      'admin',
      'sales representative',
      'warehouse employee',
    ];

    final dropdownValue = validRoles.contains(_selectedRole) ? _selectedRole : null;

    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: dropdownValue,
          decoration: InputDecoration(
            labelText: 'Select Role',
            labelStyle: const TextStyle(color: AppColors.textDark),
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
            DropdownMenuItem(value: 'admin', child: Text('Admin')),
            DropdownMenuItem(value: 'sales representative', child: Text('Sales Representative')),
            DropdownMenuItem(value: 'warehouse employee', child: Text('Warehouse Employee')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedRole = value;
              });
            }
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: () => Navigator.pop(context),
            ),
            const Spacer(),
          ],
        ),
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Edit Employee",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        height: 5,
                      ),
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateEmployee,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text("Save", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _deleteEmployee,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.deleteButton,
                      ),
                      child: const Text("Delete", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
