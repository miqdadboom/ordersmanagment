import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/user_role_access.dart';
import '../../../../core/utils/user_access_control.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              AppColors.primary,
              AppColors.primary,
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 90),
            Text(
              "Login",
              style: AppTextStyles.chatButton(context),
            ),
            const SizedBox(height: 40),
            Text(
              "Welcome Back",
              style: AppTextStyles.bodyLight(context),
            ),
            const SizedBox(height: 50),
            const Expanded(child: _LoginFormContainer()),
          ],
        ),
      ),
    );
  }
}

class _LoginFormContainer extends StatelessWidget {
  const _LoginFormContainer();

  Future<void> _handleLogin(BuildContext context) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test@gmail.com', // Replace with actual input
        password: 'password123', // Replace with actual input
      );

      final userId = userCredential.user?.uid;
      if (userId != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        final role = doc['role'] as String;

        String route = UserAccessControl.getHomeRouteForRole(role);
        Navigator.pushReplacementNamed(context, route);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(55),
          topRight: Radius.circular(55),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.boxShadow,
            blurRadius: 15,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: const LoginForm(),
    );
  }
}
