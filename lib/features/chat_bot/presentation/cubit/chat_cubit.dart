
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import '../../data/datasources/chat_database.dart';
import '../../data/models/chat_message_entity.dart';

final chatCubitProvider = StateNotifierProvider.autoDispose<ChatCubit, List<ChatMessageEntity>>(
      (ref) => ChatCubit(),
);

final isTypingProvider = StateProvider.autoDispose<bool>((ref) => false);

class ChatCubit extends StateNotifier<List<ChatMessageEntity>> {
  ChatCubit() : super([]);

  final Author _user = Author(id: '1', name: 'Adham');
  final Author _bot = Author(id: '2', name: 'ChatAi');

  final _chatGpt = OpenAI.instance.build(
    token: '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',
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
  );

  Author get user => _user;
  Author get bot => _bot;

  Future<void> loadChatHistory(int conversationId) async {
    final storedMessages = await ChatDatabase.instance.getMessages(conversationId);
    state = storedMessages.map((msg) {
      return ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: msg['content'],
        createdAt: DateTime.parse(msg['timestamp']),
        author: msg['sender'] == _user.name ? _user : _bot,
      );
    }).toList();
  }

  Future<void> sendMessage(WidgetRef ref, int conversationId, String messageText) async {
    final message = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: messageText,
      createdAt: DateTime.now(),
      author: _user,
    );

    state = [message, ...state];
    ref.read(isTypingProvider.notifier).state = true;

    await ChatDatabase.instance.insertMessage(
      conversationId,
      _user.name,
      message.text,
      'text',
    );

    await _getBotResponse(ref, conversationId);
  }

  Future<void> _getBotResponse(WidgetRef ref, int conversationId) async {
    final messagesHistory = state.reversed.map((msg) {
      return {
        'role': msg.author.id == _user.id ? 'user' : 'assistant',
        'content': msg.text,
      };
    }).toList();

    final request = ChatCompleteText(
      model: GptTurboChatModel(),
      messages: messagesHistory,
      maxToken: 1000,
    );

    final response = await _chatGpt.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        final botMessage = ChatMessageEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: element.message!.content,
          createdAt: DateTime.now(),
          author: _bot,
        );

        state = [botMessage, ...state];
        ref.read(isTypingProvider.notifier).state = false;

        await ChatDatabase.instance.insertMessage(
          conversationId,
          _bot.name,
          botMessage.text,
          'text',
        );
      }
    }
    ref.read(isTypingProvider.notifier).state = false;
  }
}
