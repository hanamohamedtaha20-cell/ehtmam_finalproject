import 'package:ehtemam_final_project/features/home_screen/manager/state/chatbot_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../data/model/chat_message_model.dart';

class ChatCubit extends Cubit<ChatbotState> {
  final ApiService apiService;

  ChatCubit(this.apiService)
      : super(ChatbotLoaded([]));

  Future<void> sendMessage({
    required String sessionId,
    required String message,
  }) async {
    try {
      List<ChatMessageModel> currentMessages = [];

      if (state is ChatbotLoaded) {
        currentMessages = List<ChatMessageModel>.from(
          (state as ChatbotLoaded).messages,
        );
      }

      currentMessages.add(
        ChatMessageModel(
          message: message,
          isUser: true,
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      emit(
        ChatbotLoaded(
          List.from(currentMessages),
        ),
      );

      final aiMessage = await apiService.sendMessage(
        sessionId: sessionId,
        message: message,
      );

      currentMessages.add(aiMessage);

      emit(
        ChatbotLoaded(
          List.from(currentMessages),
        ),
      );
    } catch (e) {
      emit(
        ChatbotError(
          e.toString(),
        ),
      );
    }
  }
}