import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<MultipartFile?> _fileToMultipart(PlatformFile? file) async {
    if (file == null) return null;

    if (file.bytes != null) {
      return MultipartFile.fromBytes(
        file.bytes!,
        filename: file.name,
      );
    }

    if (file.path != null) {
      return MultipartFile.fromFile(
        file.path!,
        filename: file.name,
      );
    }

    return null;
  }

  Future<void> signup({
    required String fullName,
    required String email,
    required String phone,
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

      final profileMultipart = await _fileToMultipart(profileFile);
      final nationalIdMultipart = await _fileToMultipart(nationalIdFile);
      final certificateMultipart = await _fileToMultipart(certificateFile);

      final Map<String, dynamic> map = {
        'full_name': fullName.trim(),
        'email': email.trim(),
        'password': password,
        'passwordConfirmation': passwordConfirmation,
        'governorate': governorate,
      };

      if (isCaregiver) {
        map.addAll({
          'phoneNumber': phone.trim(),
          'speciality': careField.toLowerCase(),
          'experience': specialization,
          'availability': 'Full-time',
          'price': '50',
        });

        if (profileMultipart != null) {
          map['profile_picture'] = profileMultipart;
        }

        if (certificateMultipart != null) {
          map['certifications'] = [certificateMultipart];
        }

        if (nationalIdMultipart != null) {
          map['verifcation_documents'] = [nationalIdMultipart];
        }
      } else {
        if (phone.trim().isNotEmpty) map['phoneNumber'] = phone.trim();
        if (street.isNotEmpty) map['address[street]'] = street;
        if (building.isNotEmpty) map['address[building]'] = building;

        if (profileMultipart != null) {
          map['profile_picture'] = profileMultipart;
        }

        if (nationalIdMultipart != null) {
          map['national_id'] = nationalIdMultipart;
        }
      }

      final formData = FormData.fromMap(map);

      final endpoint = isCaregiver ? '/caregiver/signup' : '/userlog/signup';

      final response = await apiService.postFormData(
        endpoint: endpoint,
        formData: formData,
      );

      if (response['status'] != 'success') {
        throw Exception(response['message'] ?? 'Signup failed');
      }
      final prefs = await SharedPreferences.getInstance();
      final userData = response['data'];
      if (userData != null) {
        final userId = userData['_id']?.toString() ?? '';
        final token = userData['token']?.toString() ?? '';
        if (userId.isNotEmpty) await prefs.setString('userId', userId);
        if (token.isNotEmpty) await prefs.setString('token', token);
      }
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }
}