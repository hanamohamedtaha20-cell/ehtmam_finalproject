import '../model/chat_message_model.dart';

abstract class ChatbotRepository {
  Future<List<ChatMessageModel>> getHistory();

  Future<void> sendMessage(
      String message,
      );
}