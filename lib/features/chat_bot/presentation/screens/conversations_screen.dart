import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isLoading = true;
  List<Map<String, dynamic>> conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() => isLoading = true);
    final data = await ChatDatabase.instance.getConversations();
    setState(() {
      conversations = data;
      isLoading = false;
    });
  }

  Future<void> _deleteConversation(int id) async {
    await ChatDatabase.instance.deleteConversation(id);

    final messagesCollection = FirebaseFirestore.instance
        .collection('conversations')
        .doc(id.toString())
        .collection('messages');

    final messagesSnapshot = await messagesCollection.get();
    for (final doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }

    await FirebaseFirestore.instance.collection('conversations').doc(id.toString()).delete();

    await _loadConversations();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Conversation deleted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/homeScreen'),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : conversations.isEmpty
          ? const Center(child: Text('No conversations found.'))
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
            onDelete: () => _deleteConversation(convo['id']),
          );
        },
      ),
    );
  }
}
