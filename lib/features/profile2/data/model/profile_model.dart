class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:    json['_id']?.toString()       ?? '',
      name:  json['full_name']?.toString() ?? '',
      email: json['email']?.toString()     ?? '',
      phone: json['phone']?.toString() ?? json['phoneNumber']?.toString() ?? json['phone_number']?.toString() ?? '',
      role:  json['role']?.toString()      ?? 'client',
    );
  }
}