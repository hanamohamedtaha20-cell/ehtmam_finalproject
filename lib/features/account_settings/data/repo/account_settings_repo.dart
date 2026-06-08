import 'package:ehtemam_final_project/core/network/api_service.dart';

class AccountSettingsRepo {
  final ApiService _apiService;

  AccountSettingsRepo(this._apiService);

  Future<void> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    await _apiService.updatePassword(
      currentPassword: currentPassword,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}