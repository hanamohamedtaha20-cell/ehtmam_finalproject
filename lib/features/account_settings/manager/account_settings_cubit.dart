import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_settings_state.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  AccountSettingsCubit() : super(const AccountSettingsState(profileImagePath: ''));

  Future<void> loadUserData() async {
    emit(state.copyWith(isLoading: true));

    final prefs = await SharedPreferences.getInstance();

    emit(
      state.copyWith(
        name: prefs.getString('user_name') ?? '',
        email: prefs.getString('user_email') ?? '',
        phone: prefs.getString('user_phone') ?? '',
        role: prefs.getString('user_role') ?? '',
        notifications: prefs.getBool('notifications') ?? false,
        government: prefs.getString('user_government') ?? '',
        careField: prefs.getString('care_field') ?? '',
        specialization: prefs.getString('care_specialization') ?? '',
        certificateFileName: prefs.getString('certificate_file_name') ?? '',
        isLoading: false,

      ),
    );
  }

  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);

    emit(
      state.copyWith(
        notifications: value,
        message: value
            ? 'Notifications enabled'
            : 'Notifications disabled',
      ),
    );
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));

    await Future.delayed(const Duration(seconds: 1)); // simulate

    if (newPassword != confirmPassword) {
      emit(state.copyWith(
        isLoading: false,
        error: "Passwords do not match",
      ));
      return;
    }

    emit(state.copyWith(
      isLoading: false,
      success: true,
    ));
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
  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      emit(state.copyWith(profileImagePath: image.path));
    }
  }
}