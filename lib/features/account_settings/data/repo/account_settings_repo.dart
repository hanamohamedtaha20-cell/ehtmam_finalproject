import 'package:ehtemam_final_project/core/network/api_service.dart';

class AccountSettingsRepo {
  final ApiService _apiService;

  AccountSettingsRepo(this._apiService);

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    return await _apiService.getUserProfile(userId);
  }

  Future<Map<String, dynamic>> deleteAccount() async {
    return await _apiService.deleteAccount();
  }

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