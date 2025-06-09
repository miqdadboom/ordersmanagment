import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size_box.dart';
import '../../../../core/utils/app_exception.dart';
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
          throw ServerException('No role data found for this user');
        }

        final role = snapshot.data()!['role'];

        if (role == 'admin' ||
            role == 'salesRepresentative' ||
            role == 'warehouseEmployee') {
          Navigator.pushReplacementNamed(context, '/ProductsScreen');
        } else {
          throw ServerException('Unknown role');
        }
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'network-request-failed') {
          message = NoInternetException().message;
        } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          message = ServerException('Invalid email or password').message;
        } else {
          message = UnknownException(e.message ?? 'Unknown Firebase error').message;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      } on AppException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected error: $e'), backgroundColor: Colors.red),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;

        return Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWideScreen ? 40 : 20,
                vertical: isWideScreen ? 40 : 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWideScreen ? 400 : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isWideScreen)
                      const Text(
                        "Login to Your Account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (isWideScreen) const SizedBox(height: 30),
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
                    AppSizedBox.height(context, 0.01),
                    SizedBox(
                      width: isWideScreen ? 200 : double.infinity,
                      child: LoginButton(
                        onPressed: _handleLogin,
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.buttonText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
