import 'package:flutter/material.dart';
import '../../data/datasources/chat_database.dart';
import '../../data/datasources/firebase_conversations.dart';

class ConversationsCubit extends ChangeNotifier {
  bool isLoading = true;
  List<Map<String, dynamic>> conversations = [];

  Future<void> loadConversations() async {
    isLoading = true;
    notifyListeners();

    final data = await ChatDatabase.instance.getConversations();
    conversations = data;
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteConversation(int id) async {
    await ChatDatabase.instance.deleteConversation(id);
    await FirebaseConversations.deleteConversation(id);
    await loadConversations();
  }
}
