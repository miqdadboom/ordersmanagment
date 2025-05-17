import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/add_employee_appbar.dart';
import '../widgets/add_employee_text_field.dart';
import '../widgets/add_save_button.dart';
import 'manage_employee_screen.dart';


class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _jobController = TextEditingController();
  final _addressController = TextEditingController();
  final _distributionController = TextEditingController();

  final Color primaryColor =  AppColors.primary;

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final confirm = await _showConfirmationDialog(
        context,
        'Confirm Save',
        'Are you sure you want to save this employee?',
      );

      if (confirm) {
        print('Saved: ${_nameController.text} - ${_jobController.text}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee saved successfully')),
        );
        _clearFields();
      }
    }
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _jobController.clear();
    _addressController.clear();
    _distributionController.clear();
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: const Text('Confirm'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmployeeAppBar(primaryColor: primaryColor),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 48),
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
                  controller: _phoneController,
                  hintText: "Phone",
                  icon: Icons.phone,
                  validatorMessage: 'Please enter the phone number',
                  primaryColor: primaryColor,
                ),
                EmployeeTextField(
                  controller: _jobController,
                  hintText: "Job Title",
                  icon: Icons.work,
                  validatorMessage: 'Please enter the job title',
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
                const SizedBox(height: 40),
                SaveButton(
                  onPressed: () => _submitForm(context),
                  color: primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
