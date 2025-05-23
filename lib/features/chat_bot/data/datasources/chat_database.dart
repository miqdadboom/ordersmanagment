import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChatDatabase {
  static final ChatDatabase instance = ChatDatabase._init();
  static Database? _database;

  ChatDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chat_history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE conversations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        last_message TEXT,
        last_updated TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        conversation_id INTEGER,
        sender TEXT,
        content TEXT,
        timestamp TEXT,
        type TEXT,
        FOREIGN KEY (conversation_id) REFERENCES conversations (id)
      )
    ''');
  }

  Future<int> createConversation(String title) async {
    final db = await instance.database;
    int id = await db.insert('conversations', {
      'title': title,
      'last_message': '',
      'last_updated': DateTime.now().toIso8601String(),
    });

    await FirebaseFirestore.instance.collection('conversations').doc(id.toString()).set({
      'title': title,
      'last_message': '',
      'last_updated': DateTime.now().toIso8601String(),
    });

    return id;
  }

  Future<void> updateConversation(int conversationId, String lastMessage) async {
    final db = await instance.database;
    await db.update(
      'conversations',
      {
        'last_message': lastMessage,
        'last_updated': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [conversationId],
    );
  }

  Future<void> insertMessage(int conversationId, String sender, String content, String type) async {
    final db = await instance.database;
    await db.insert('messages', {
      'conversation_id': conversationId,
      'sender': sender,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
      'type': type,
    });
    await updateConversation(conversationId, content);


    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId.toString())
        .collection('messages')
        .add({
      'sender': sender,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
      'type': type,
    });
  }

  Future<List<Map<String, dynamic>>> getConversations() async {
    final db = await instance.database;
    return await db.query('conversations', orderBy: 'last_updated DESC');
  }

  Future<List<Map<String, dynamic>>> getMessages(int conversationId) async {
    final db = await instance.database;
    return await db.query(
      'messages',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      orderBy: 'timestamp DESC',
    );
  }

  Future<void> deleteConversation(int conversationId) async {
    final db = await instance.database;

    await db.delete(
      'messages',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
    );

    await db.delete(
      'conversations',
      where: 'id = ?',
      whereArgs: [conversationId],
    );

    await FirebaseFirestore.instance.collection('conversations').doc(conversationId.toString()).delete();

  }
}
