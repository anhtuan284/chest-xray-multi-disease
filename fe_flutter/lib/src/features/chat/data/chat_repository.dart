import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_message.dart';

class ChatRepository {
  static const String _storageKey = 'chat_messages';
  static const int _maxMessages = 20;

  ChatRepository();

  Future<List<ChatMessage>> getMessages() async {
    final prefs = await SharedPreferences.getInstance();

    final String? data = prefs.getString(_storageKey);
    if (data == null) return [];

    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => ChatMessage.fromJson(json)).toList();
  }

  Future<void> saveMessages(List<ChatMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();

    // Keep only latest 20 messages
    final messagesToSave = messages.length > _maxMessages
        ? messages.sublist(messages.length - _maxMessages)
        : messages;

    final jsonList = messagesToSave.map((msg) => msg.toJson()).toList();
    await prefs.setString(_storageKey, json.encode(jsonList));
  }
}
