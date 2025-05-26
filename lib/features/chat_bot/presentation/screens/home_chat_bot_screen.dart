import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/core/utils/user_access_control.dart';
import 'package:final_tasks_front_end/features/chat_bot/presentation/widgets/animated_intro.dart';
import 'package:final_tasks_front_end/features/chat_bot/presentation/widgets/features_section.dart';
import 'package:final_tasks_front_end/features/chat_bot/presentation/widgets/start_chat_button.dart';
import '../../../../core/user_role_access.dart';
import 'conversations_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _role;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    final role = await UserRoleAccess.getUserRole();
    if (!mounted) return;
    setState(() {
      _role = role;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!UserAccessControl.HomeScreen(_role!)) {
      return const Scaffold(
        body: Center(child: Text("You are not authorized to access this page.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.secondary, AppColors.primary],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: AppColors.backgroundChat,
                title: const Text(
                  "Chat Ai",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Cera Pro",
                    fontSize: 32,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AnimatedIntro(),
                        FeaturesSection(),
                        SizedBox(height: 15),
                        StartChatButton(),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/conversationScreen');
        },
        child: Icon(Icons.chat_outlined, color: AppColors.background, size: 35),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
