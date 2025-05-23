import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/chat_cubit.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final int conversationId;
  const ChatScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(chatCubitProvider.notifier).loadChatHistory(widget.conversationId);
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatCubitProvider);
    final chatCubit = ref.read(chatCubitProvider.notifier);
    final user = chatCubit.user;
    final bot = chatCubit.bot;
    final isTyping = ref.watch(isTypingProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Chat Bot",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pushReplacementNamed(context, '/homeScreen'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: DashChat(
              currentUser: user,
              onSend: (message) => chatCubit.sendMessage(ref, widget.conversationId, message),
              messages: messages,
              typingUsers: isTyping ? [bot] : [],
              messageOptions: MessageOptions(
                textColor: AppColors.textDark,
                currentUserContainerColor: AppColors.primary,
                currentUserTextColor: AppColors.textLight,
              ),
              inputOptions: InputOptions(
                inputDecoration: InputDecoration(
                  hintText: "Write a message...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
