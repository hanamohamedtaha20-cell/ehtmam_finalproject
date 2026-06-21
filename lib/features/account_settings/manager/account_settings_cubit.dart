import 'package:ehtemam_final_project/features/account_settings/data/repo/account_settings_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_settings_state.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  final AccountSettingsRepo repo;

  AccountSettingsCubit(this.repo) : super(const AccountSettingsState(profileImagePath: ''));

  Future<void> loadUserData() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, error: null));

    final prefs = await SharedPreferences.getInstance();

    try {
      final userId = prefs.getString('userId') ?? '';
      String? apiSpeciality;

      if (userId.isNotEmpty) {
        final response = await repo.getUserProfile(userId);
        debugPrint('ACCOUNT_SETTINGS_RAW_RESPONSE: $response');

        // Navigate all possible nested paths
        final dataVal = response['data'];
        final dataMap = dataVal is Map ? Map<String, dynamic>.from(dataVal) : null;
        final userVal = dataMap?['user'];
        final userMap = userVal is Map ? Map<String, dynamic>.from(userVal) : null;
        final cgVal   = dataMap?['caregiver'];
        final cgMap   = cgVal   is Map ? Map<String, dynamic>.from(cgVal)   : null;

        // Search every possible location — first non-empty wins
        String? str(dynamic v) => v?.toString().trim();
        apiSpeciality =
            str(response['speciality'])
            ?? str(response['specialty'])
            ?? str(dataMap?['speciality'])
            ?? str(dataMap?['specialty'])
            ?? str(userMap?['speciality'])
            ?? str(userMap?['specialty'])
            ?? str(cgMap?['speciality'])
            ?? str(cgMap?['specialty']);

        if (apiSpeciality != null && apiSpeciality.isEmpty) apiSpeciality = null;
        debugPrint('SPECIALITY_FROM_API: $apiSpeciality');

        // Pick the best user object for the other profile fields
        final user = dataMap ?? response;

        final name = user['full_name']?.toString()
            ?? user['fullName']?.toString()
            ?? prefs.getString('user_name') ?? '';
        final email = user['email']?.toString()
            ?? prefs.getString('user_email') ?? '';
        final phone = user['phoneNumber']?.toString()
            ?? user['phone']?.toString()
            ?? prefs.getString('user_phone') ?? '';
        final government = user['governorate']?.toString()
            ?? user['government']?.toString()
            ?? prefs.getString('user_government') ?? '';
        final profileImageUrl = user['profile_picture']?.toString()
            ?? user['profilePicture']?.toString()
            ?? user['avatar']?.toString()
            ?? '';

        debugPrint('PROFILE_IMAGE_URL: $profileImageUrl');

        await prefs.setString('user_name', name);
        await prefs.setString('user_email', email);
        await prefs.setString('user_phone', phone);
        await prefs.setString('user_government', government);
        if (profileImageUrl.isNotEmpty) {
          await prefs.setString('profile_picture_url', profileImageUrl);
        }
        if (apiSpeciality != null && apiSpeciality.isNotEmpty) {
          await prefs.setString('speciality', apiSpeciality);
          await prefs.setString('care_field', apiSpeciality);
        }
      }

      // Resolve final value: API result → 'speciality' pref → 'care_field' pref → 'care_specialization'
      debugPrint('SPECIALITY_FROM_PREFS: ${prefs.getString('speciality')}');
      final rawSpeciality = apiSpeciality
          ?? prefs.getString('speciality')
          ?? prefs.getString('care_field')
          ?? prefs.getString('care_specialization')
          ?? '';
      final speciality = _toTitleCase(rawSpeciality);
      debugPrint('STATE_SPECIALITY: $speciality');

      if (!isClosed) {
        emit(
          state.copyWith(
            name: prefs.getString('user_name') ?? '',
            email: prefs.getString('user_email') ?? '',
            phone: prefs.getString('user_phone') ?? '',
            role: prefs.getString('user_role') ?? '',
            government: prefs.getString('user_government') ?? '',
            notifications: prefs.getBool('notifications') ?? false,
            careField: speciality,
            speciality: speciality,
            specialization: prefs.getString('care_specialization') ?? '',
            certificateFileName: prefs.getString('certificate_file_name') ?? '',
            profileImageUrl: prefs.getString('profile_picture_url') ?? '',
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      debugPrint('[AccountSettingsCubit] loadUserData error: $e');
      final rawSpeciality = prefs.getString('speciality')
          ?? prefs.getString('care_field')
          ?? '';
      if (!isClosed) {
        emit(
          state.copyWith(
            name: prefs.getString('user_name') ?? '',
            email: prefs.getString('user_email') ?? '',
            phone: prefs.getString('user_phone') ?? '',
            role: prefs.getString('user_role') ?? '',
            government: prefs.getString('user_government') ?? '',
            notifications: prefs.getBool('notifications') ?? false,
            careField: _toTitleCase(rawSpeciality),
            speciality: _toTitleCase(rawSpeciality),
            isLoading: false,
            error: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);

    if (!isClosed) {
      emit(
        state.copyWith(
          notifications: value,
          message: value
              ? 'Notifications enabled'
              : 'Notifications disabled',
        ),
      );
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, error: null));

    if (newPassword != confirmPassword) {
      if (!isClosed) {
        emit(state.copyWith(
          isLoading: false,
          error: "Passwords do not match",
          message: "Passwords do not match",
        ));
      }
      return;
    }

    try {
      await repo.changePassword(
        currentPassword: oldPassword,
        password: newPassword,
        passwordConfirmation: confirmPassword,
      );
      if (!isClosed) {
        emit(state.copyWith(
          isLoading: false,
          success: true,
          message: "Password changed successfully",
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          isLoading: false,
          error: e.toString(),
          message: e.toString(),
        ));
      }
    }
  }

  Future<void> saveRegisterData({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    String government = '',
    String careField = '',
    String specialization = '',
    String certificateFileName = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_phone', phone);
    await prefs.setString('user_password', password);
    await prefs.setString('user_role', role);
    await prefs.setString('user_government', government);
    await prefs.setString('care_field', careField);
    await prefs.setString('care_specialization', specialization);
    await prefs.setString('certificate_file_name', certificateFileName);
  }

  /// Deletes the user's account using the role-specific endpoint.
  /// Returns null on success, a friendly error message on failure.
  Future<String?> deleteAccount() async {
    if (!isClosed) emit(state.copyWith(isLoading: true));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role  = prefs.getString('user_role') ?? '';

    if (token == null || token.isEmpty) {
      if (!isClosed) emit(state.copyWith(isLoading: false));
      return 'You must be logged in to delete your account.';
    }

    try {
      await repo.deleteAccount(role: role);
      await prefs.clear();
      if (!isClosed) emit(state.copyWith(isLoading: false));
      return null;
    } catch (e) {
      if (!isClosed) emit(state.copyWith(isLoading: false));
      return _friendlyDeleteError(e);
    }
  }

  String _friendlyDeleteError(Object e) {
    try {
      // ignore: avoid_dynamic_calls
      final dynamic dioE = e;
      final resp = dioE.response;
      if (resp != null) {
        final body = resp.data;
        if (body is Map) {
          final msg = body['message'] ?? body['error'] ?? body['msg'];
          if (msg != null) return msg.toString();
        }
        return 'Server error (${resp.statusCode}). Please try again.';
      }
    } catch (_) {}
    return 'Failed to delete account. Please try again.';
  }

  String _toTitleCase(String value) {
    if (value.isEmpty) return value;
    return value.split(' ').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}').join(' ');
  }

  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      if (!isClosed) {
        emit(state.copyWith(profileImagePath: image.path));
      }
    }
  }
  
}
