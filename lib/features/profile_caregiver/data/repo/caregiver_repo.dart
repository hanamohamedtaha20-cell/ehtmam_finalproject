import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/data/model/caregiver_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CaregiverRepo {
  final ApiService _api;
  CaregiverRepo([ApiService? api]) : _api = api ?? ApiService();

  Future<CaregiverModel> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';

    Map<String, dynamic> profile = {};
    Map<String, dynamic>? walletData;

    if (userId.isNotEmpty) {
      try {
        final res = await _api.getUserProfile(userId);
        final raw = res['data'];
        if (raw is Map<String, dynamic>) profile = raw;
      } catch (_) {}

      try {
        final res = await _api.getMyWallet();
        final raw = res['data'];
        if (raw is Map<String, dynamic>) walletData = raw;
      } catch (_) {}
    }

    if (profile.isEmpty) {
      return CaregiverModel.fromPrefs(
        name: prefs.getString('user_name') ?? '',
        email: prefs.getString('user_email') ?? '',
        phone: prefs.getString('user_phone') ?? '',
        location: prefs.getString('user_government') ?? '',
        specialty: prefs.getString('care_field') ?? prefs.getString('care_specialization') ?? '',
      );
    }

    return CaregiverModel.fromApiData(
      profile: profile,
      wallet: walletData,
      govFallback: prefs.getString('user_government') ?? '',
      phoneFallback: prefs.getString('user_phone') ?? '',
    );
  }
}
