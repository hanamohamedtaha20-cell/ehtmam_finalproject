import '../../data/model/chat_message_model.dart';

abstract class ChatbotState {}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoading extends ChatbotState {}

class ChatbotLoaded extends ChatbotState {
  final List<ChatMessageModel> messages;

  ChatbotLoaded(this.messages);
}

class ChatbotError extends ChatbotState {
  final String message;

  ChatbotError(this.message);
}