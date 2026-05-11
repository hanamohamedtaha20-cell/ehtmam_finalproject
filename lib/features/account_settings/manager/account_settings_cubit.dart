import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_phone', phone);
    await prefs.setString('user_password', password);
    await prefs.setString('user_role', role);
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