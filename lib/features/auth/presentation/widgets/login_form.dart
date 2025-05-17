import 'package:flutter/material.dart';
import 'InputField .dart';
import 'LoginButton.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
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
        SnackBar(content: Text('Validate')),
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
          ),
          InputField(
            controller: _passwordController,
            hint: "Password",
            icon: Icons.lock_outline,
            obscureText: true,
          ),
          SizedBox(height: 35),
          LoginButton(onPressed: _handleLogin),
        ],
      ),
    );
  }
}
