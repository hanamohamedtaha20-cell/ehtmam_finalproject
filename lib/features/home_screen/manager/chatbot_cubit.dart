import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../data/model/chat_message_model.dart';
import 'state/chatbot_state.dart';

class ChatCubit extends Cubit<ChatbotState> {
  final ApiService apiService;
  String? _sessionId;

  ChatCubit(this.apiService) : super(const ChatbotLoaded([]));

  Future<void> sendMessage(String message) async {
    if (state is! ChatbotLoaded) return;

    final currentMessages = List<ChatMessageModel>.from(
      (state as ChatbotLoaded).messages,
    );

    currentMessages.add(ChatMessageModel(
      message: message,
      isUser: true,
      createdAt: DateTime.now().toIso8601String(),
    ));

    emit(ChatbotLoaded(List.from(currentMessages), isTyping: true));

    try {
      _sessionId ??= await apiService.createChatSession();

      final aiContent = await apiService.sendChatMessage(
        sessionId: _sessionId!,
        message: message,
      );

      currentMessages.add(ChatMessageModel(
        message: aiContent,
        isUser: false,
        createdAt: DateTime.now().toIso8601String(),
      ));

      emit(ChatbotLoaded(List.from(currentMessages)));
    } catch (e) {
      currentMessages.add(ChatMessageModel(
        message: 'Sorry, something went wrong. Please try again.',
        isUser: false,
        createdAt: DateTime.now().toIso8601String(),
      ));
      emit(ChatbotLoaded(List.from(currentMessages)));
    }
  }
}
