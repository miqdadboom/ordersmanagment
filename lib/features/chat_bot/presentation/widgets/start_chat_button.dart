import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/datasources/chat_database.dart';
import '../screens/chat_screen.dart';

class StartChatButton extends StatelessWidget {
  const StartChatButton({super.key});

  Future<void> _startNewChat(BuildContext context) async {
    String? conversationTitle = await showDialog<String>(
      context: context,
      builder: (context) {
        String tempTitle = "";
        return AlertDialog(
          title: const Text("New Conversation"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: "Enter conversation title"),
            onChanged: (value) => tempTitle = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, tempTitle.isEmpty ? "New Chat" : tempTitle),
              child: const Text("Create"),
            ),
          ],
        );
      },
    );

    if (conversationTitle != null) {
      final newConversationId = await ChatDatabase.instance.createConversation(conversationTitle);
      Navigator.pushReplacementNamed(
        context, '/chatScreen',
        arguments: {'id': newConversationId},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _startNewChat(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.background,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      child: Text(
        "Start New Chat",
        style: TextStyle(
          color: AppColors.textDark,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: "Cera Pro",
        ),
      ),
    );
  }
}
