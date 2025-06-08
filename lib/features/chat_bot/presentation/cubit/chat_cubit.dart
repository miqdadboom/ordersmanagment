import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import '../../data/datasources/chat_database.dart';
import '../../data/models/chat_message_entity.dart';
import '../../../../core/utils/app_exception.dart';

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
    try {
      final storedMessages = await ChatDatabase.instance.getMessages(conversationId);
      state = storedMessages.map((msg) {
        return ChatMessageEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: msg['content'],
          createdAt: DateTime.parse(msg['timestamp']),
          author: msg['sender'] == _user.name ? _user : _bot,
        );
      }).toList();
    } catch (e) {
      debugPrint(" Error loading chat history: $e");
    }
  }

  Future<void> sendMessage(WidgetRef ref, int conversationId, String messageText, BuildContext context) async {
    try {
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

      await _getBotResponse(ref, conversationId, context);
    } catch (e) {
      _handleError(e, context, ref);
    }
  }

  Future<void> _getBotResponse(WidgetRef ref, int conversationId, BuildContext context) async {
    try {
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

      final response = await _chatGpt.onChatCompletion(request: request)
      .timeout(const Duration(seconds: 10));
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
    } on SocketException catch (e) {
      debugPrint('Socket Exception: $e');
      _handleError(NoInternetException(), context, ref);
    } on HttpException catch (e) {
      debugPrint('HTTP Exception: $e');
      if (e.message.contains('timeout') || e.message.contains('timed out')) {
        _handleError(TimeoutException(), context, ref);
      } else {
        _handleError(ServerException(e.message), context, ref);
      }
    } on FormatException catch (e) {
      debugPrint('Format Exception: $e');
      _handleError(ParseException(), context, ref);
    } catch (e) {
      debugPrint('Unknown Exception: $e');
      if (e.toString().contains('SocketException') || 
          e.toString().contains('Connection failed') ||
          e.toString().contains('Network is unreachable')) {
        _handleError(NoInternetException(), context, ref);
      } else if (e.toString().contains('timeout') || e.toString().contains('timed out')) {
        _handleError(TimeoutException(), context, ref);
      } else if (e.toString().contains('connection') || e.toString().contains('connect')) {
        _handleError(ConnectionException(), context, ref);
      } else {
        _handleError(UnknownException(e.toString()), context, ref);
      }
    }
  }

  void _handleError(Object e, BuildContext context, WidgetRef ref) {
    ref.read(isTypingProvider.notifier).state = false;
    final msg = e is AppException ? e.message : "An unexpected error occurred. Please try again.";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
