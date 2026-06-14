import 'package:ehtemam_final_project/features/home_screen/manager/chatbot_cubit.dart';
import 'package:ehtemam_final_project/features/home_screen/manager/state/chatbot_state.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/widgets/language_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_service.dart';
import '../../data/model/chat_message_model.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ChatCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ChatCubit(ApiService());
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    _cubit.sendMessage(text);
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xffE9EDF2),
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              const SizedBox(height: 18),
              Expanded(
                child: BlocConsumer<ChatCubit, ChatbotState>(
                  listener: (context, state) {
                    if (state is ChatbotLoaded) {
                      Future.delayed(
                        const Duration(milliseconds: 100),
                        _scrollToBottom,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ChatbotLoaded) {
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            state.messages.length + (state.isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (state.isTyping &&
                              index == state.messages.length) {
                            return _buildTypingIndicator();
                          }
                          return _buildMessage(state.messages[index]);
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              _buildInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff2B7CD3), Color(0xff3A8BE0)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "✨ AI Assistant",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Powered by Artificial Intelligence",
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          LanguageSwitcher(),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessageModel message) {
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xff3A8BE0) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.message,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(delay: 0),
            SizedBox(width: 4),
            _Dot(delay: 150),
            SizedBox(width: 4),
            _Dot(delay: 300),
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: "Type message",
                  hintStyle:
                      TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14),
                ),
              ),
            ),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: const Color(0xff3A8BE0),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff3A8BE0).withValues(alpha: .4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
    _anim = Tween(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: const CircleAvatar(
        radius: 4,
        backgroundColor: Color(0xff3A8BE0),
      ),
    );
  }
}
