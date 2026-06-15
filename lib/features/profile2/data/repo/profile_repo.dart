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
    final raw = Map<String, dynamic>.from(data);
    final phone = raw['phoneNumber']?.toString() ??
        raw['phone']?.toString() ??
        raw['phone_number']?.toString() ??
        prefs.getString('user_phone') ??
        '';
    return UserModel(
      id:    raw['_id']?.toString()       ?? '',
      name:  raw['full_name']?.toString() ?? '',
      email: raw['email']?.toString()     ?? '',
      phone: phone,
      role:  raw['role']?.toString()      ?? 'client',
    );
  }

  Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await _api.getMyRequests();
      final list = response['data'] as List? ?? [];
      final total = list.length;
      final completed = list
          .where((r) =>
              (r['status'] ?? '').toString().toUpperCase() == 'COMPLETED')
          .length;
      return {'total': total, 'completed': completed};
    } catch (_) {
      return {'total': 0, 'completed': 0};
    }
  }
}