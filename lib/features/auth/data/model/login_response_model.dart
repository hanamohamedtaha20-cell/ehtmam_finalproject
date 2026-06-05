class LoginResponseModel {
  final String status;
  final String message;
  final String token;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.token,
  });

  factory LoginResponseModel.fromJson(
      Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'],
      message: json['message'],
      token: json['data'],
    );
  }
}