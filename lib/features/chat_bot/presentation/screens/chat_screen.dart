import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:final_tasks_front_end/core/constants/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/chat_message_entity.dart';
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

  ChatUser toChatUser(Author author) {
    return ChatUser(
      id: author.id,
      firstName: author.name,
    );
  }

  ChatMessage toChatMessage(ChatMessageEntity entity) {
    return ChatMessage(
      text: entity.text,
      user: toChatUser(entity.author),
      createdAt: entity.createdAt,
    );
  }

  @override
  Widget build(BuildContext context) {
    final entityMessages = ref.watch(chatCubitProvider);
    final chatCubit = ref.read(chatCubitProvider.notifier);
    final user = toChatUser(chatCubit.user);
    final bot = toChatUser(chatCubit.bot);
    final messages = entityMessages.map(toChatMessage).toList();
    final isTyping = ref.watch(isTypingProvider);

    return Scaffold(
      appBar: CustomAppBar(
          title: 'Chat Bot',
        customLeading: IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/homeScreen'),
            icon: Icon(Icons.arrow_back),
          color: AppColors.textLight,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: DashChat(
              currentUser: user,
              onSend: (message) =>
                  chatCubit.sendMessage(ref, widget.conversationId, message.text),
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
