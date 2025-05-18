import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'InputField .dart';
import 'LoginButton.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      print("Login successful");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          InputField(
            controller: _emailController,
            hint: "Email or phone number",
            icon: Icons.email_outlined,
            borderColor: AppColors.primary,
            fillColor: AppColors.background,
            iconColor: AppColors.primary,
            textColor: AppColors.textDark,
          ),
          InputField(
            controller: _passwordController,
            hint: "Password",
            icon: Icons.lock_outline,
            obscureText: true,
            borderColor: AppColors.primary,
            fillColor: AppColors.background,
            iconColor: AppColors.primary,
            textColor: AppColors.textDark,
          ),
          const SizedBox(height: 35),
          LoginButton(
            onPressed: _handleLogin,
            backgroundColor: AppColors.primary,
            textColor: AppColors.buttonText,
          ),
        ],
      ),
    );
  }
}
