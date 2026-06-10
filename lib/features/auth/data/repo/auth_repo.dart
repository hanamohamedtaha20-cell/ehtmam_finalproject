import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/login_response_model.dart';

class AuthRepo {
  final ApiService apiService;

  AuthRepo(this.apiService);

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final cleanEmail = email.trim().replaceAll(' ', '');
      final cleanPassword = password.trim();

      final data = await apiService.loginClient(
        email: cleanEmail,
        password: cleanPassword,
      );

      if (data['status'] != 'success') {
        throw Exception(data['message'] ?? 'Login failed');
      }

      final loginResponse =
          LoginResponseModel.fromJson(Map<String, dynamic>.from(data));

      if (loginResponse.token.isEmpty) {
        throw Exception('Login response missing token');
      }

      return loginResponse;
    } catch (e) {
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
