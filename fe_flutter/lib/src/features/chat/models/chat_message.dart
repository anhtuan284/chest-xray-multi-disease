import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_message.g.dart';

abstract class ChatMessage implements Built<ChatMessage, ChatMessageBuilder> {
  String get message;
  bool get isUser;
  DateTime get timestamp;

  ChatMessage._();
  factory ChatMessage([void Function(ChatMessageBuilder) updates]) =
      _$ChatMessage;

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static ChatMessage fromJson(Map<String, dynamic> json) {
    return ChatMessage((b) => b
      ..message = json['message']
      ..isUser = json['isUser']
      ..timestamp = DateTime.parse(json['timestamp']));
  }

  static Serializer<ChatMessage> get serializer => _$chatMessageSerializer;
}
