import '../models/chat_message.dart';

class ChatSeed {
  static const String aiName = "Dr. AI Assistant";
  static const String aiAvatarAsset = "assets/images/ai_avatar.png";

  static List<ChatMessage> getInitialMessages() {
    return [
      ChatMessage((b) => b
        ..message =
            "Hello! I'm Dr. AI Assistant. I can help you analyze chest X-ray images and provide medical insights. How can I assist you today?"
        ..isUser = false
        ..timestamp = DateTime.now().subtract(const Duration(minutes: 1))),
      ChatMessage((b) => b
        ..message =
            "You can ask me questions about:\n• Chest X-ray analysis\n• Disease patterns\n• Medical terminology\n• Previous cases"
        ..isUser = false
        ..timestamp = DateTime.now()),
    ];
  }
}
