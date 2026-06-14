import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/profile_model.dart';

class ProfileRepo {
  final ApiService _api = ApiService();

  Future<UserModel> getUser() async {
    final prefs  = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    if (userId.isEmpty) throw Exception('User ID not found. Please log in again.');
    final result = await _api.getUserProfile(userId);
    final data = result['data'];
    if (data == null) throw Exception('Profile data not found');
    return UserModel.fromJson(Map<String, dynamic>.from(data));
  }
}