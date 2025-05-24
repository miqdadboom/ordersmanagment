// firebase_conversations.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseConversations {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> deleteConversation(int id) async {
    final docRef = _firestore.collection('conversations').doc(id.toString());

    final messagesCollection = docRef.collection('messages');
    final messagesSnapshot = await messagesCollection.get();
    for (final doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }

    await docRef.delete();
  }
}
