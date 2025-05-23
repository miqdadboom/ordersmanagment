import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
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
          children: const [
            SizedBox(height: 90),
            Text(
              "Login",
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Text(
              "Welcome Back",
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 50),
            Expanded(
              child: _LoginFormContainer(),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginFormContainer extends StatelessWidget {
  const _LoginFormContainer();

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
