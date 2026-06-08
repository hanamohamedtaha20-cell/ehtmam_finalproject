import 'package:ehtemam_final_project/features/home_screen/manager/state/chatbot_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/chat_repo.dart';

class ChatbotCubit
    extends Cubit<ChatbotState> {

  final ChatbotRepository repository;

  ChatbotCubit(this.repository)
      : super(ChatbotInitial());

  Future<void> loadMessages() async {
    emit(ChatbotLoading());

    try {
      final messages =
      await repository.getHistory();

      emit(
        ChatbotLoaded(messages),
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