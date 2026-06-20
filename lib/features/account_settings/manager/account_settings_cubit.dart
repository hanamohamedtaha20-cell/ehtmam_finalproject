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

      if (userId.isNotEmpty) {
        final response = await repo.getUserProfile(userId);

        final user = response['data'];

        final name = user?['full_name'] ?? user?['fullName'] ?? prefs.getString('user_name') ?? '';
        final email = user?['email'] ?? prefs.getString('user_email') ?? '';
        final phone = user?['phoneNumber'] ?? user?['phone'] ?? prefs.getString('user_phone') ?? '';
        final government = user?['governorate']?.toString()
            ?? user?['government']?.toString()
            ?? prefs.getString('user_government') ?? '';

        final profileImageUrl = user?['profile_picture']?.toString()
            ?? user?['profilePicture']?.toString()
            ?? user?['avatar']?.toString()
            ?? '';
        debugPrint('PROFILE_IMAGE_URL: $profileImageUrl');
        debugPrint('RAW_GOVERNMENT_FIELDS: governorate=${user?['governorate']} government=${user?['government']} address=${user?['address']}');

        // Extract care field — backend stores it as 'speciality'
        final careFieldFromApi = user?['speciality']?.toString()
            ?? user?['specialty']?.toString()
            ?? user?['careField']?.toString()
            ?? '';
        debugPrint('CARE_FIELD_FROM_API: $careFieldFromApi');
        debugPrint('CARE_FIELDS_FROM_API: ${user?['careFields'] ?? user?['specialities'] ?? ''}');

        final resolvedCareField = careFieldFromApi.isNotEmpty
            ? careFieldFromApi
            : (prefs.getString('care_field') ?? '');

        await prefs.setString('user_name', name);
        await prefs.setString('user_email', email);
        await prefs.setString('user_phone', phone);
        await prefs.setString('user_government', government);
        if (profileImageUrl.isNotEmpty) {
          await prefs.setString('profile_picture_url', profileImageUrl);
        }
        if (resolvedCareField.isNotEmpty) {
          await prefs.setString('care_field', resolvedCareField);
        }
      }
      debugPrint('LOADED NAME => ${prefs.getString('user_name')}');
      debugPrint('LOADED EMAIL => ${prefs.getString('user_email')}');
      debugPrint('LOADED PHONE => ${prefs.getString('user_phone')}');
      debugPrint('LOADED GOV => ${prefs.getString('user_government')}');
      debugPrint('LOADED CARE_FIELD => ${prefs.getString('care_field')}');
      debugPrint('LOADED PROFILE_IMAGE_URL => ${prefs.getString('profile_picture_url')}');

      if (!isClosed) {
        emit(
          state.copyWith(
            name: prefs.getString('user_name') ?? '',
            email: prefs.getString('user_email') ?? '',
            phone: prefs.getString('user_phone') ?? '',
            role: prefs.getString('user_role') ?? '',
            government: prefs.getString('user_government') ?? '',
            notifications: prefs.getBool('notifications') ?? false,
            careField: prefs.getString('care_field') ?? '',
            specialization: prefs.getString('care_specialization') ?? '',
            certificateFileName: prefs.getString('certificate_file_name') ?? '',
            profileImageUrl: prefs.getString('profile_picture_url') ?? '',
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            name: prefs.getString('user_name') ?? '',
            email: prefs.getString('user_email') ?? '',
            phone: prefs.getString('user_phone') ?? '',
            role: prefs.getString('user_role') ?? '',
            government: prefs.getString('user_government') ?? '',
            notifications: prefs.getBool('notifications') ?? false,
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

  /// Deletes the user's account from the backend, clears all local data.
  /// Returns null on success, a friendly error message on failure.
  Future<String?> deleteAccount() async {
    if (!isClosed) emit(state.copyWith(isLoading: true));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    debugPrint('[DeleteAccount] token exists: ${token.isNotEmpty}');

    if (token.isEmpty) {
      if (!isClosed) emit(state.copyWith(isLoading: false));
      return 'You must be logged in to delete your account.';
    }

    try {
      final response = await repo.deleteAccount();
      debugPrint('[DeleteAccount] response: $response');

      await _clearAllPrefs(prefs);
      if (!isClosed) emit(state.copyWith(isLoading: false));
      return null;
    } catch (e) {
      debugPrint('[DeleteAccount] error: $e');
      if (!isClosed) emit(state.copyWith(isLoading: false));
      return _friendlyDeleteError(e);
    }
  }

  Future<void> _clearAllPrefs(SharedPreferences prefs) async {
    await prefs.clear();
  }

  String _friendlyDeleteError(Object e) {
    try {
      // ignore: avoid_dynamic_calls
      final dynamic dioE = e;
      final resp = dioE.response;
      if (resp != null) {
        debugPrint('[DeleteAccount] statusCode: ${resp.statusCode}');
        debugPrint('[DeleteAccount] response data: ${resp.data}');
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
