import 'user_model.dart';

class LoginResponseModel {
  final String status;
  final String message;
  final String token;
  final UserModel user;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    if (rawData is! Map) {
      throw const FormatException('Login response missing data object');
    }

    final data = Map<String, dynamic>.from(rawData);
    final rawUser = data['user'];
    if (rawUser is! Map) {
      throw const FormatException('Login response missing user object');
    }

    return LoginResponseModel(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      token: data['token']?.toString() ?? '',
      user: UserModel.fromJson(Map<String, dynamic>.from(rawUser)),
    );
  }
}
