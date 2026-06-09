import 'package:ehtemam_final_project/features/account_settings/data/repo/account_settings_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_settings_state.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  final AccountSettingsRepo repo;

  AccountSettingsCubit(this.repo) : super(const AccountSettingsState(profileImagePath: ''));

  Future<void> loadUserData() async {
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
        final government = user?['government'] ?? prefs.getString('user_government') ?? '';

        await prefs.setString('user_name', name);
        await prefs.setString('user_email', email);
        await prefs.setString('user_phone', phone);
        await prefs.setString('user_government', government);
      }
      print("LOADED NAME => ${prefs.getString('user_name')}");
      print("LOADED EMAIL => ${prefs.getString('user_email')}");
      print("LOADED PHONE => ${prefs.getString('user_phone')}");
      print("LOADED GOV => ${prefs.getString('user_government')}");

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
          isLoading: false,
        ),
      );
    } catch (e) {
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

    if (newPassword != confirmPassword) {
      emit(state.copyWith(
        isLoading: false,
        error: "Passwords do not match",
        message: "Passwords do not match",
      ));
      return;
    }

    try {
      await repo.changePassword(
        currentPassword: oldPassword,
        password: newPassword,
        passwordConfirmation: confirmPassword,
      );
      emit(state.copyWith(
        isLoading: false,
        success: true,
        message: "Password changed successfully",
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
        message: e.toString(),
      ));
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