import 'package:final_tasks_front_end/core/constants/app_size_box.dart';
import 'package:final_tasks_front_end/core/constants/custom_app_bar.dart';
import 'package:flutter/material.dart';
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
              CustomAppBar(title: 'Chat Ai'),
               Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01,
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AnimatedIntro(),
                        FeaturesSection(),
                        AppSizedBox.height(context, 0.02),
                        StartChatButton(),
                        AppSizedBox.height(context, 0.04),
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
