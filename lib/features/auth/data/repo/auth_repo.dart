import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';

class AuthRepo {
  final ApiService apiService;

  AuthRepo(this.apiService);

  Future<String> login({
    required String email,
    required String password,
  }) async {
  //   try {
  //     print('=== LOGIN REQUEST ===');
  //   print('Email: $email');
  //   print('Password: $password');
  //     final data = await apiService.loginClient(
  //       email: email,
  //       password: password,
  //     );
  //     print('=== LOGIN RESPONSE ===');
  //   print('Response: $data');
  //     return data['data'];
  //   } catch (e) {
  //      print('=== LOGIN ERROR ===');
  //   print('Error: $e');
  //     throw Exception('Login failed: $e');
  //   }
  // }
  try {
    final cleanEmail = email.trim().replaceAll(' ', '');
    final cleanPassword = password.trim();
    
    print('Clean Email: "$cleanEmail"');
    print('Clean Password: "$cleanPassword"');
    
    final data = await apiService.loginClient(
      email: cleanEmail,
      password: cleanPassword,
    );

    final token = data['data']?.toString();
    if (token == null || token.isEmpty) {
      throw Exception(data['message']?.toString() ?? 'Login failed');
    }

    return token;
  } catch (e) {
    print('Error: $e');
    throw Exception('Login failed: $e');
  }
}

  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
    String governorate = '',
    String street = '',
    String building = '',
    PlatformFile? profileFile,
    PlatformFile? nationalIdFile,
    PlatformFile? certificateFile,
    String careField = '',
    String specialization = '',
  }) async {
    try {
      final bool isCaregiver = role.toLowerCase().contains('care');

      final formData = FormData.fromMap({
        'full_name':            fullName,
        'email':                email,
        'password':             password,
        'passwordConfirmation': passwordConfirmation,
        if (isCaregiver) ...{
          'speciality': careField.toLowerCase(),
          'experience': specialization,
        },
        if (profileFile?.bytes != null)
          'profile_picture': MultipartFile.fromBytes(
            profileFile!.bytes!,
            filename: profileFile.name,
          ),
        if (nationalIdFile?.bytes != null)
          'national_id': MultipartFile.fromBytes(
            nationalIdFile!.bytes!,
            filename: nationalIdFile.name,
          ),
        if (governorate.isNotEmpty) 'governorate': governorate,
        if (street.isNotEmpty) 'address[street]': street,
        if (building.isNotEmpty) 'address[building]': building,
        if (isCaregiver && certificateFile?.bytes != null)
          'certifications': MultipartFile.fromBytes(
            certificateFile!.bytes!,
            filename: certificateFile.name,
          ),
      });

      final endpoint = isCaregiver ? '/caregiver/signup' : '/userlog/signup';
      final response = await apiService.postFormData(endpoint: endpoint, formData: formData);
      print("SIGNUP RESPONSE: $response");
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }
}