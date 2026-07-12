import 'package:ehtemam_final_project/core/network/api_constants.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/data/model/caregiver_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CaregiverRepo {
  final ApiService _api;
  CaregiverRepo([ApiService? api]) : _api = api ?? ApiService();

  Future<CaregiverModel> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';

    Map<String, dynamic> profile = {};
    Map<String, dynamic>? walletData;
    List<Map<String, dynamic>> reviewsList = [];
    int completedBookingsCount = 0;

    if (userId.isNotEmpty) {
      // Fetch profile, caregiver data, wallet, reviews, bookings in parallel
      final results = await Future.wait([
        _api.getUserProfile(userId).catchError((_) => <String, dynamic>{}),
        _api.getCaregiverById(userId).catchError((_) => <String, dynamic>{}),
        _api.getMyWallet().catchError((_) => <String, dynamic>{}),
        _api.getMyReviews().catchError((_) => <String, dynamic>{}),
        _api.getMyBookings().catchError((_) => <String, dynamic>{}),
      ]);

      // ── Profile (user log) ───────────────────────────────────────────────
      final profileRes = results[0];
      final profileRaw = profileRes['data'];
      if (profileRaw is Map<String, dynamic>) {
        profile = profileRaw;
      } else if (profileRes.isNotEmpty && profileRes['data'] == null) {
        profile = profileRes;
      }
      debugPrint('CAREGIVER_PROFILE_RAW: $profile');

      // ── Caregiver-specific data (has profile_picture) ────────────────────
      final caregiverRes = results[1];
      final caregiverRaw = caregiverRes['data'];
      final caregiverData = caregiverRaw is Map<String, dynamic>
          ? caregiverRaw
          : (caregiverRes.isNotEmpty ? caregiverRes : <String, dynamic>{});
      debugPrint('CAREGIVER_DATA_RAW: $caregiverData');
      debugPrint('RAW profile_picture (caregiver): ${caregiverData['profile_picture']}');
      // Merge: caregiver endpoint fields take priority for picture, specialty
      if (caregiverData.isNotEmpty) {
        profile = {...caregiverData, ...profile};
        // Caregiver endpoint's profile_picture is more reliable — keep it
        final cgPic = caregiverData['profile_picture']?.toString() ?? '';
        if (cgPic.isNotEmpty) profile['profile_picture'] = cgPic;
      }

      // ── Wallet ───────────────────────────────────────────────────────────
      final walletRes = results[2];
      final walletRaw = walletRes['data'];
      if (walletRaw is Map<String, dynamic>) walletData = walletRaw;

      // ── Reviews ──────────────────────────────────────────────────────────
      final reviewsRes = results[3];
      debugPrint('CAREGIVER_REVIEWS_RAW: $reviewsRes');
      final dataVal = reviewsRes['data'] ??
          reviewsRes['reviews'] ??
          reviewsRes['results'];
      if (dataVal is List) {
        reviewsList = dataVal.whereType<Map<String, dynamic>>().toList();
      } else if (reviewsRes['data'] is Map) {
        final inner = (reviewsRes['data'] as Map)['reviews'] ??
            (reviewsRes['data'] as Map)['data'];
        if (inner is List) {
          reviewsList = inner.whereType<Map<String, dynamic>>().toList();
        }
      }
      debugPrint('CAREGIVER_REVIEWS_COUNT: ${reviewsList.length}');

      // ── Bookings: count completed ────────────────────────────────────────
      final bookingsRes = results[4];
      final bookingsRaw = bookingsRes['data'] ?? bookingsRes;
      final bookingsList = bookingsRaw is List
          ? bookingsRaw
          : (bookingsRaw is Map ? bookingsRaw['data'] ?? [] : []);
      for (final b in bookingsList) {
        if (b is! Map) continue;
        final status = (b['status'] ?? b['bookingStatus'] ?? '')
            .toString()
            .toUpperCase();
        if (status == 'COMPLETED') completedBookingsCount++;
      }
      debugPrint('COMPLETED_BOOKINGS_COUNT: $completedBookingsCount');
    }

    if (profile.isEmpty) {
      final savedPicture = prefs.getString('profile_picture_url') ?? '';
      debugPrint('MODEL profilePicture (from prefs fallback): $savedPicture');
      return CaregiverModel.fromPrefs(
        name: prefs.getString('user_name') ?? '',
        email: prefs.getString('user_email') ?? '',
        phone: prefs.getString('user_phone') ?? '',
        location: prefs.getString('user_government') ?? '',
        specialty: prefs.getString('care_field') ??
            prefs.getString('care_specialization') ??
            '',
        profilePicture: savedPicture,
      );
    }

    // ── Resolve profile picture URL ──────────────────────────────────────
    final rawPicture = profile['profile_picture']?.toString() ??
        profile['profilePicture']?.toString() ??
        profile['avatar']?.toString() ??
        prefs.getString('profile_picture_url') ??
        '';
    final pictureUrl = _resolveUrl(rawPicture);
    debugPrint('MODEL profilePicture: $pictureUrl');
    debugPrint('Caregiver governorate: ${profile['governorate']}');
    debugPrint('Caregiver rating: ${profile['averageRating']}');

    return CaregiverModel.fromApiData(
      profile: profile,
      wallet: walletData,
      reviewsList: reviewsList,
      completedBookingsCount: completedBookingsCount,
      govFallback: prefs.getString('user_government') ?? '',
      phoneFallback: prefs.getString('user_phone') ?? '',
      profilePictureUrl: pictureUrl,
    );
  }

  static String _resolveUrl(String raw) {
    if (raw.isEmpty) return '';
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    // relative path → prepend base URL
    final base = baseUrl.endsWith('/') ? baseUrl : baseUrl;
    return '$base$raw';
  }
}
