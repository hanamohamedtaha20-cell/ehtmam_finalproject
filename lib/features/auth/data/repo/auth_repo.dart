import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:ehtemam_final_project/core/network/api_constants.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/login_response_model.dart';

class AuthRepo {
  final ApiService apiService;

  AuthRepo(this.apiService);

  // ── Login ──────────────────────────────────────────────────────────────────

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

  // ── File helpers ───────────────────────────────────────────────────────────

  String _mimeType(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }

  Future<MultipartFile?> _fileToMultipart(PlatformFile? file) async {
    if (file == null) return null;

    final mime = DioMediaType.parse(_mimeType(file.name));

    if (file.path != null && file.path!.isNotEmpty) {
      return MultipartFile.fromFile(
        file.path!,
        filename: file.name,
        contentType: mime,
      );
    }

    if (file.bytes != null) {
      return MultipartFile.fromBytes(
        file.bytes!,
        filename: file.name,
        contentType: mime,
      );
    }

    return null;
  }

  // ── Signup ─────────────────────────────────────────────────────────────────

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
    PlatformFile? mentalHealthFile,
    String careField = '',
    String specialization = '',
  }) async {
    try {
      final bool isCaregiver = role.toLowerCase().contains('care');
      final endpoint = isCaregiver ? '/caregiver/signup' : '/userlog/signup';
      final url = '$baseUrl$endpoint';

      // ── Convert files ──────────────────────────────────────────────────────
      final profileMultipart      = await _fileToMultipart(profileFile);
      final nationalIdMultipart   = await _fileToMultipart(nationalIdFile);
      final certificateMultipart  = await _fileToMultipart(certificateFile);
      final mentalHealthMultipart = await _fileToMultipart(mentalHealthFile);

      // ── Before-request debug ───────────────────────────────────────────────
      debugPrint('========== CAREGIVER SIGNUP ==========');
      debugPrint('URL: $url');
      debugPrint('name: ${fullName.trim()}');
      debugPrint('email: ${email.trim()}');
      debugPrint('phone: ${phone.trim()}');
      debugPrint('role: $role');
      debugPrint('governorate: $governorate');
      debugPrint('speciality: ${careField.toLowerCase()}');
      debugPrint('experience: $specialization');
      debugPrint('profilePicture: ${profileFile?.path}');
      debugPrint('nationalId: ${nationalIdFile?.path}');
      debugPrint('certifications: ${certificateFile?.path}');
      debugPrint('mentalHealthDocument: ${mentalHealthFile?.path}');

      // ── Build form data ────────────────────────────────────────────────────
      final Map<String, dynamic> map = {
        'full_name': fullName.trim(),
        'email': email.trim(),
        'password': password,
        'passwordConfirmation': passwordConfirmation,
        'governorate': governorate,
      };

      if (isCaregiver) {
        map.addAll({
          'phoneNumber':  phone.trim(),
          'speciality':   careField.toLowerCase(),
          'experience':   specialization,
          'availability': 'available',
          'price':        '500',
        });

        if (profileMultipart != null) {
          map['profile_picture'] = profileMultipart;
        }
        if (nationalIdMultipart != null) {
          map['national_id'] = nationalIdMultipart;
        }
        if (certificateMultipart != null) {
          map['certifications'] = [certificateMultipart];
        }
        if (mentalHealthMultipart != null) {
          map['mental_health_document'] = mentalHealthMultipart;
        }
      } else {
        if (phone.trim().isNotEmpty) map['phoneNumber'] = phone.trim();
        if (street.isNotEmpty) map['address[street]'] = street;
        if (building.isNotEmpty) map['address[building]'] = building;
        if (profileMultipart != null) map['profile_picture'] = profileMultipart;
        if (nationalIdMultipart != null) map['national_id'] = nationalIdMultipart;
      }

      final formData = FormData.fromMap(map);

      // ── Print every multipart field and file before sending ────────────────
      debugPrint('---------- FORM FIELDS ----------');
      for (final f in formData.fields) {
        debugPrint('FIELD => ${f.key}: ${f.value}');
      }
      debugPrint('---------- FORM FILES ----------');
      for (final f in formData.files) {
        debugPrint('FILE => ${f.key}: ${f.value.filename}');
      }
      debugPrint('========================================');

      // ── Send ───────────────────────────────────────────────────────────────
      final response = await apiService.postFormData(
        endpoint: endpoint,
        formData: formData,
      );

      // postFormData returns Map<String, dynamic> (Dio already throws on non-2xx)
      debugPrint('STATUS CODE: 200/201');
      debugPrint('RESPONSE DATA: $response');

      if (response['status'] != 'success') {
        final msg = response['message']?.toString() ?? 'Signup failed';
        debugPrint('[Signup] backend returned error: $msg');
        throw Exception(msg);
      }

      // ── Persist user data ──────────────────────────────────────────────────
      final prefs = await SharedPreferences.getInstance();
      final userData = response['data'];
      if (userData != null) {
        final userId = userData['_id']?.toString() ?? '';
        final token  = userData['token']?.toString() ?? '';
        if (userId.isNotEmpty) await prefs.setString('userId', userId);
        if (token.isNotEmpty)  await prefs.setString('token', token);
      }
    } catch (e) {
      if (e is DioException) {
        // Full error already printed in api_service.dart postFormData.
        throw Exception('Registration failed. Check console logs.');
      }
      // Re-throw clean Exception messages (e.g. "Email already exists").
      rethrow;
    }
  }
}
