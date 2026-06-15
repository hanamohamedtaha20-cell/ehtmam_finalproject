class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String phone;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.phone = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:       json['_id']?.toString()       ?? '',
      fullName: json['full_name']?.toString() ?? '',
      email:    json['email']?.toString()     ?? '',
      role:     json['role']?.toString()      ?? '',
      phone:    json['phone']?.toString() ?? json['phoneNumber']?.toString() ?? json['phone_number']?.toString() ?? '',
    );
  }
}