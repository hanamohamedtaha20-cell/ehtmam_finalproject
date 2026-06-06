import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/profile_model.dart';

class ProfileRepo {
  final ApiService _api = ApiService();

  Future<UserModel> getUser() async {
    final prefs  = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    final result = await _api.getUserProfile(userId);
    return UserModel.fromJson(result['data']);
  }
}