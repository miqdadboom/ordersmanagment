import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'InputField .dart';
import 'LoginButton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final uid = credential.user!.uid;

        final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (!snapshot.exists) {
          throw Exception('No role data found for this user');
        }

        final role = snapshot.data()!['role'];


        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/productScreen');
        } else if (role == 'sales representative') {
          Navigator.pushReplacementNamed(context, '/productScreen');

        } else if (role == 'warehouse employee') {
          Navigator.pushReplacementNamed(context, '/productScreen');
        } else {
          throw Exception('Unknown role');
        }

      } on FirebaseAuthException catch (e) {
        String message = 'Login failed.';
        if (e.code == 'user-not-found') message = 'No user found for that email.';
        else if (e.code == 'wrong-password') message = 'Wrong password provided.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.teal,
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