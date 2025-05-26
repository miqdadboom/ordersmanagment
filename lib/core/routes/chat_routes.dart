import 'package:flutter/material.dart';
import '../../../features/chat_bot/presentation/screens/home_chat_bot_screen.dart';
import '../../../features/chat_bot/presentation/screens/conversations_screen.dart';
import '../../../features/chat_bot/presentation/screens/chat_screen.dart';

final Map<String, WidgetBuilder> chatRoutes = {
  '/homeScreen': (context) => const HomeScreen(),
  '/conversationScreen': (context) => const ConversationsScreen(),
  '/chatScreen': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ChatScreen(conversationId: args['id']);
  },
};
