import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_service.dart';
import '../data/model/chat_message_model.dart';
import 'state/chatbot_state.dart';

class ChatCubit extends Cubit<ChatbotState> {
  final ApiService apiService;
  String? _sessionId;

  ChatCubit(this.apiService) : super(const ChatbotLoaded([]));

  // ── Persistence helpers ──────────────────────────────────────

  Future<String> _historyKey() async {
    final prefs = await SharedPreferences.getInstance();
    final isGuest = prefs.getBool('is_guest') ?? false;
    if (isGuest) return 'guest_chat_history';
    final userId = prefs.getString('userId') ?? '';
    return userId.isNotEmpty ? 'ai_chat_history_$userId' : 'guest_chat_history';
  }

  Future<void> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _historyKey();
      final raw = prefs.getString(key);
      debugPrint('[ChatHistory] loading key=$key  raw=${raw == null ? "null" : "${raw.length} chars"}');
      if (raw == null || raw.isEmpty) return;
      final list = jsonDecode(raw) as List;
      final messages = list
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList();
      debugPrint('[ChatHistory] loaded ${messages.length} messages');
      if (!isClosed) emit(ChatbotLoaded(messages));
    } catch (e) {
      debugPrint('[ChatHistory] load error: $e');
    }
  }

  Future<void> _saveHistory(List<ChatMessageModel> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _historyKey();
      final raw = jsonEncode(messages.map((m) => m.toJson()).toList());
      await prefs.setString(key, raw);
      debugPrint('[ChatHistory] saved ${messages.length} messages to key=$key');
    } catch (e) {
      debugPrint('[ChatHistory] save error: $e');
    }
  }

  // ── Clear history ────────────────────────────────────────────

  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _historyKey();
      await prefs.remove(key);
      debugPrint('[ChatHistory] cleared key=$key');
    } catch (e) {
      debugPrint('[ChatHistory] clear error: $e');
    }
    _sessionId = null;
    if (!isClosed) emit(const ChatbotLoaded([]));
  }

  // ── Send message ─────────────────────────────────────────────

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
      await _saveHistory(currentMessages);
    } catch (e) {
      currentMessages.add(ChatMessageModel(
        message: 'Sorry, something went wrong. Please try again.',
        isUser: false,
        createdAt: DateTime.now().toIso8601String(),
      ));
      emit(ChatbotLoaded(List.from(currentMessages)));
      await _saveHistory(currentMessages);
    }
  }
}
