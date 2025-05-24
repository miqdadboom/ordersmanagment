import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cubit/conversations_cubit.dart';
import '../widgets/conversation_item.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConversationsCubit()..loadConversations(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Conversations'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacementNamed(context, '/homeScreen'),
          ),
        ),
        body: Consumer<ConversationsCubit>(
          builder: (context, cubit, child) {
            if (cubit.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (cubit.conversations.isEmpty) {
              return const Center(child: Text('No conversations found.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: cubit.conversations.length,
              itemBuilder: (context, index) {
                final convo = cubit.conversations[index];
                return ConversationItem(
                  title: convo['title'] ?? 'Untitled',
                  lastMessage: convo['last_message'] ?? '',
                  lastUpdated: convo['last_updated']?.split('T').first ?? '',
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/chatScreen',
                      arguments: {'id': convo['id']},
                    );
                  },
                  onDelete: () async {
                    await cubit.deleteConversation(convo['id']);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Conversation deleted successfully')),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
