import 'package:flutter/foundation.dart';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String phone;
  final String status;
  final String speciality;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.phone = '',
    this.status = '',
    this.speciality = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    debugPrint('SPECIALITY_FROM_API: ${json['speciality']}');
    return UserModel(
      id:         json['_id']?.toString()       ?? '',
      fullName:   json['full_name']?.toString() ?? '',
      email:      json['email']?.toString()     ?? '',
      role:       json['role']?.toString()      ?? '',
      phone:      json['phone']?.toString()
                  ?? json['phoneNumber']?.toString()
                  ?? json['phone_number']?.toString()
                  ?? '',
      status:     json['status']?.toString()    ?? '',
      speciality: json['speciality']?.toString()
                  ?? json['specialty']?.toString()
                  ?? '',
    );
  }
}
