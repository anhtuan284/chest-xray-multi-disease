import 'package:fe_flutter/src/core/models/api_models.dart'; // Add this import
import 'package:fe_flutter/src/core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/chat_api_service.dart';
import '../data/chat_repository.dart';
import '../models/chat_message.dart';

class ChatController extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final ChatAPIService _chatService;
  final ChatRepository _repository;

  ChatController(this._chatService, this._repository)
      : super(const AsyncValue.loading()) {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    state = const AsyncValue.loading();
    try {
      final messages = await _repository.getMessages();
      state = AsyncValue.data(messages);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final currentMessages = state.value ?? [];

    // Add user message immediately
    final userMessage = ChatMessage((b) => b
      ..message = message
      ..isUser = true
      ..timestamp = DateTime.now());

    state = AsyncValue.data([...currentMessages, userMessage]);
    await _repository.saveMessages(state.value!);

    // Add "typing" indicator
    final typingMessage = ChatMessage((b) => b
      ..message = "Typing..."
      ..isUser = false
      ..timestamp = DateTime.now());

    state = AsyncValue.data([...state.value!, typingMessage]);

    try {
      // Call API with retry mechanism
      SearchResponse? response;
      int retries = 3;

      while (retries > 0) {
        try {
          response = await _chatService.sendMessage(message);
          break;
        } catch (e) {
          retries--;
          if (retries == 0) rethrow;
          await Future.delayed(const Duration(seconds: 1));
        }
      }

      // Remove typing indicator and add actual response
      final messages = state.value!..removeLast();
      final aiMessage = ChatMessage((b) => b
        ..message =
            response?.answer ?? "Sorry, I couldn't process your request."
        ..isUser = false
        ..timestamp = DateTime.now());

      state = AsyncValue.data([...messages, aiMessage]);
      await _repository.saveMessages(state.value!);
    } catch (e, stack) {
      // Remove typing indicator
      final messages = state.value!..removeLast();

      // Add error message
      final errorMessage = ChatMessage((b) => b
        ..message =
            "Sorry, I'm having trouble connecting. Please check your internet connection and try again."
        ..isUser = false
        ..timestamp = DateTime.now());

      state = AsyncValue.data([...messages, errorMessage]);
      await _repository.saveMessages(state.value!);

      // Log error
      print('Chat error: $e\n$stack');
    }
  }
}

final chatControllerProvider =
    StateNotifierProvider<ChatController, AsyncValue<List<ChatMessage>>>((ref) {
  return ChatController(
    ref.watch(chatAPIProvider),
    ref.watch(chatRepositoryProvider),
  );
});
