import 'package:flutter/material.dart';
import '../../data/datasources/chat_database.dart';
import '../widgets/conversation_item.dart';
import 'chat_screen.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  List<Map<String, dynamic>> conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    final data = await ChatDatabase.instance.getConversations();
    setState(() {
      conversations = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: conversations.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final convo = conversations[index];
          return ConversationItem(
            title: convo['title'] ?? 'Untitled',
            lastMessage: convo['last_message'] ?? '',
            lastUpdated: convo['last_updated']?.split('T').first ?? '',
            onTap: () {
              Navigator.pushReplacementNamed(
                context, '/chatScreen',
                arguments: {'id': convo['id']},
              );
            },
          );
        },
      ),
    );
  }
}
