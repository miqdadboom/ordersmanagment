import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import '../../data/datasources/chat_database.dart';

final chatCubitProvider = StateNotifierProvider.autoDispose<ChatCubit, List<ChatMessage>>(
      (ref) => ChatCubit(),
);

final isTypingProvider = StateProvider.autoDispose<bool>((ref) => false);

class ChatCubit extends StateNotifier<List<ChatMessage>> {
  ChatCubit() : super([]);

  final _user = ChatUser(id: '1', firstName: 'Adham');
  final _bot = ChatUser(id: '2', firstName: 'ChatAi');

  final _chatGpt = OpenAI.instance.build(
    token: '',
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
  );

  ChatUser get user => _user;
  ChatUser get bot => _bot;

  Future<void> loadChatHistory(int conversationId) async {
    final storedMessages = await ChatDatabase.instance.getMessages(conversationId);
    state = storedMessages.map((msg) {
      return ChatMessage(
        text: msg['content'],
        user: msg['sender'] == _user.firstName ? _user : _bot,
        createdAt: DateTime.parse(msg['timestamp']),
      );
    }).toList();
  }

  Future<void> sendMessage(WidgetRef ref, int conversationId, ChatMessage message) async {
    state = [message, ...state];
    ref.read(isTypingProvider.notifier).state = true;

    await ChatDatabase.instance.insertMessage(
      conversationId,
      _user.firstName!,
      message.text,
      'text',
    );

    await _getBotResponse(ref, conversationId);
  }

  Future<void> _getBotResponse(WidgetRef ref, int conversationId) async {
    final messagesHistory = state.reversed.map((msg) {
      return {
        'role': msg.user == _user ? 'user' : 'assistant',
        'content': msg.text
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
        final botMessage = ChatMessage(
          text: element.message!.content,
          user: _bot,
          createdAt: DateTime.now(),
        );
        state = [botMessage, ...state];
        ref.read(isTypingProvider.notifier).state = false;

        await ChatDatabase.instance.insertMessage(
          conversationId,
          _bot.firstName!,
          botMessage.text,
          'text',
        );
      }
    }
    ref.read(isTypingProvider.notifier).state = false;
  }
}
