import '../../data/model/chat_message_model.dart';

abstract class ChatbotState {
  const ChatbotState();
}

class ChatbotInitial extends ChatbotState {
  const ChatbotInitial();
}

class ChatbotLoading extends ChatbotState {
  const ChatbotLoading();
}

class ChatbotLoaded extends ChatbotState {
  final List<ChatMessageModel> messages;
  final bool isTyping;

  const ChatbotLoaded(this.messages, {this.isTyping = false});
}

class ChatbotError extends ChatbotState {
  final String message;

  const ChatbotError(this.message);
}