class ChatMessageModel {
  final String message;
  final bool isUser;
  final String createdAt;

  ChatMessageModel({
    required this.message,
    required this.isUser,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'role': isUser ? 'user' : 'assistant',
    'message': message,
    'createdAt': createdAt,
  };

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      message: json['message']?.toString()
            ?? json['content']?.toString()
            ?? '',
      isUser: json['role'] == 'user',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}