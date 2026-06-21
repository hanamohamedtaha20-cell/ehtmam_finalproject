import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/request_screen_caregiver/data/model/care_request.dart';
import 'package:ehtemam_final_project/features/request_screen_caregiver/data/repo/repository_implementation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'hc_state.dart';

class HcCubit extends Cubit<HcState> {
  final CareRequestsRepositoryImpl _requestsRepo;
  final ApiService _apiService;

  HcCubit({
    CareRequestsRepositoryImpl? requestsRepo,
    ApiService? apiService,
  })  : _requestsRepo =
            requestsRepo ?? CareRequestsRepositoryImpl(ApiService()),
        _apiService = apiService ?? ApiService(),
        super(const HcState());

  Future<void> loadDashboard() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final prefs = await SharedPreferences.getInstance();
      final isAvailable = prefs.getBool('caregiver_is_available') ?? true;
      final caregiverId = prefs.getString('user_id') ??
          prefs.getString('userId') ??
          prefs.getString('_id') ??
          prefs.getString('id') ??
          '';
      final userName =
          prefs.getString('user_name') ?? prefs.getString('userName') ?? 'Caregiver';

      // Parallel fetch: requests, reviews, bookings.
      final results = await Future.wait([
        _requestsRepo.getAllRequests(),
        _apiService.getMyReviews().catchError((_) => <String, dynamic>{}),
        _apiService.getMyBookings().catchError((_) => <String, dynamic>{}),
      ]);

      final requests = (results[0] as List).cast<CareRequestModel>();
      final reviewsResponse = results[1] as Map<String, dynamic>;
      final bookingsResponse = results[2] as Map<String, dynamic>;

      // ── Requests ──────────────────────────────────────────────────────
      final pending = requests
          .where((r) => r.status == 'Pending')
          .toList();
      final accepted = requests
          .where((r) =>
              r.status == 'Accepted' ||
              r.status == 'Completed' ||
              r.status == 'In Progress')
          .toList();

      // ── Rating from GET /review/my-reviews ────────────────────────────
      final reviewData = reviewsResponse['data'] ?? reviewsResponse;
      double averageRating = 0;
      int totalReviewsCount = 0;
      if (reviewData is Map) {
        averageRating = _parseDouble(
            reviewData['averageRating'] ?? reviewData['average_rating'] ?? 0);
        totalReviewsCount = _parseInt(reviewData['totalReviewsCount'] ??
            reviewData['totalReviews'] ??
            reviewData['total'] ??
            reviewData['count'] ??
            0);
      }
      final ratingDisplay =
          totalReviewsCount == 0 ? '0.0' : averageRating.toStringAsFixed(1);

      // ── Completed bookings: count + this-week earnings ─────────────────
      final bookingsList = _extractList(bookingsResponse);
      final now = DateTime.now();
      final weekStart = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: now.weekday - 1));

      int completedBookingsCount = 0;
      double completedEarnings = 0;

      for (final b in bookingsList) {
        final map = b as Map<String, dynamic>;

        // 1. Must be COMPLETED status.
        final status = (map['status'] ??
                map['bookingStatus'] ??
                '')
            .toString()
            .toUpperCase();
        if (status != 'COMPLETED') continue;

        // 2. Must belong to the logged-in caregiver.
        final caregiverField = map['caregiver'];
        final bookingCaregiverId = caregiverField is Map
            ? caregiverField['_id']?.toString()
            : caregiverField?.toString();
        if (caregiverId.isNotEmpty &&
            bookingCaregiverId != null &&
            bookingCaregiverId.isNotEmpty &&
            bookingCaregiverId != caregiverId) {
          continue;
        }

        // 3. Checkout must be done.
        // Backend uses checkout / checkoutTime / checkoutAt / checkout_time.
        // A COMPLETED booking with any truthy checkout field qualifies.
        // If no checkout field exists, COMPLETED status itself implies checkout done.
        final checkoutRaw = map['checkout'] ??
            map['checkoutTime'] ??
            map['checkoutAt'] ??
            map['checkout_time'] ??
            map['checkOut'];
        final checkoutDone = checkoutRaw == null ||
            checkoutRaw == true ||
            (checkoutRaw is String && checkoutRaw.isNotEmpty);
        if (!checkoutDone) continue;

        completedBookingsCount++;

        // Only count earnings from this week.
        final dateStr = map['createdAt']?.toString() ??
            map['updatedAt']?.toString() ??
            '';
        final date = DateTime.tryParse(dateStr);
        if (date != null && !date.isBefore(weekStart)) {
          completedEarnings += _priceFromBooking(map);
        }
      }

      debugPrint('CAREGIVER_ID: $caregiverId');
      debugPrint('AVERAGE_RATING: $averageRating');
      debugPrint('TOTAL_REVIEWS: $totalReviewsCount');
      debugPrint('COMPLETED_BOOKINGS_COUNT: $completedBookingsCount');
      debugPrint('COMPLETED_EARNINGS: $completedEarnings');

      if (isClosed) return;
      emit(state.copyWith(
        isLoading: false,
        isAvailable: isAvailable,
        userName: userName,
        requestsToday: pending.length,
        earningsThisWeek: completedEarnings.round(),
        rating: ratingDisplay,
        activeHours: '$completedBookingsCount',
        pendingRequests: pending,
        acceptedBookings: accepted,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> toggleAvailability(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('caregiver_is_available', value);
    emit(state.copyWith(isAvailable: value));
    if (value) {
      await loadDashboard();
    }
  }

  Future<void> respondToRequest({
    required String requestId,
    required String action,
  }) async {
    try {
      await _requestsRepo.respondToRequest(
        requestId: requestId,
        action: action,
      );
      await loadDashboard();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  static double _priceFromBooking(Map<String, dynamic> map) {
    final offer = map['offer'];
    if (offer is Map) {
      return _parseDouble(offer['price'] ?? map['price'] ?? 0);
    }
    return _parseDouble(map['price'] ?? 0);
  }

  static List<dynamic> _extractList(dynamic response) {
    if (response is List) return response;
    if (response is Map) {
      final data = response['data'];
      if (data is List) return data;
    }
    return [];
  }

  static double _parseDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }

  static int _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}
