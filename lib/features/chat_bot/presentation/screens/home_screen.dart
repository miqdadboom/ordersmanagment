import 'package:final_tasks_front_end/features/chat_bot/presentation/widgets/animated_intro.dart';
import 'package:final_tasks_front_end/features/chat_bot/presentation/widgets/features_section.dart';
import 'package:final_tasks_front_end/features/chat_bot/presentation/widgets/start_chat_button.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'conversations_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundChat,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundChat,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                context, '/conversationScreen',
              );
            },
            icon: const Icon(Icons.menu, size: 40),
          ),
          title: const Text(
            "Chat Ai",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Cera Pro",
              fontSize: 32,
            ),
          ),
          centerTitle: true,
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedIntro(),
                FeaturesSection(),
                SizedBox(height: 30),
                StartChatButton(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
