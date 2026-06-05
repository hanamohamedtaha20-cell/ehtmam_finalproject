import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_service.dart';

class AuthRepo {
  final ApiService apiService;

  AuthRepo(this.apiService);

  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      print("Sending login request with email: $email");

      final response = await apiService.post(
        endpoint: ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print("Login status code: ${response.statusCode}");
      print("Login response: ${response.data}");

      return response.data['data'];
    } on DioException catch (e) {
      print("LOGIN DIO ERROR TYPE: ${e.type}");
      print("LOGIN DIO ERROR MESSAGE: ${e.message}");
      print("LOGIN DIO ERROR STATUS: ${e.response?.statusCode}");
      print("LOGIN DIO ERROR DATA: ${e.response?.data}");

      throw Exception(e.response?.data['message'] ?? 'Login failed');
    } catch (e) {
      print("UNKNOWN LOGIN ERROR: $e");
      throw Exception('Login failed');
    }
  }

  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
    PlatformFile? profileFile,
    PlatformFile? nationalIdFile,
    PlatformFile? certificateFile,
    String careField = '',
    String specialization = '',
  }) async {
    try {
      final bool isCaregiver = role.toLowerCase().contains('care');

      print("Sending signup request");
      print("Role: $role");
      print("Is caregiver: $isCaregiver");
      print("Endpoint: ${isCaregiver ? ApiConstants.caregiverSignup : ApiConstants.signup}");
      print("Email: $email");
      print("Full name: $fullName");
      print("Profile file: ${profileFile?.name}");
      print("National ID file: ${nationalIdFile?.name}");
      print("Certificate file: ${certificateFile?.name}");

      final formData = FormData.fromMap({
        'full_name': fullName,
        'email': email,
        'password': password,
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

        if (isCaregiver && certificateFile?.bytes != null)
          'certifications': MultipartFile.fromBytes(
            certificateFile!.bytes!,
            filename: certificateFile.name,
          ),
      });

      final response = await apiService.post(
        endpoint: isCaregiver
            ? ApiConstants.caregiverSignup
            : ApiConstants.signup,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print("Signup status code: ${response.statusCode}");
      print("Signup response: ${response.data}");
    } on DioException catch (e) {
      print("SIGNUP DIO ERROR TYPE: ${e.type}");
      print("SIGNUP DIO ERROR MESSAGE: ${e.message}");
      print("SIGNUP DIO ERROR STATUS: ${e.response?.statusCode}");
      print("SIGNUP DIO ERROR DATA: ${e.response?.data}");

      throw Exception(e.response?.data['message'] ?? 'Signup failed');
    } catch (e) {
      print("UNKNOWN SIGNUP ERROR: $e");
      throw Exception('Signup failed');
    }
  }
}