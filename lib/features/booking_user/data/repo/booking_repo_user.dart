import 'package:flutter/foundation.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/booking_model_user.dart';

class BookingRepoUser {
  final ApiService _api = ApiService();

  Future<List<BookingModelUser>> getBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (token.isEmpty) throw Exception('not_authenticated');

    final currentUserId = prefs.getString('userId') ?? '';

    final result = await _api.getMyBookings();

    // Backend may return { data: [...] } OR { data: { bookings: [...] } }
    final raw = result['data'];
    final List<dynamic> list;
    if (raw is List) {
      list = raw;
    } else if (raw is Map) {
      final nested = raw['bookings'] ?? raw['data'] ?? [];
      list = nested is List ? nested : [];
    } else {
      list = [];
    }

    debugPrint('[BookingRepo] total bookings from API: ${list.length}');

    // Sort newest first before enrichment so the final list order is preserved.
    list.sort((a, b) {
      final aStr = (a as Map)['createdAt']?.toString() ?? (a)['_id']?.toString() ?? '';
      final bStr = (b as Map)['createdAt']?.toString() ?? (b)['_id']?.toString() ?? '';
      return bStr.compareTo(aStr);
    });

    final bookings = <BookingModelUser>[];

    for (final b in list) {
      try {
        final booking = Map<String, dynamic>.from(b);

        // client may be a plain String ID or a populated Map { _id: ..., full_name: ... }
        final clientField = booking['client'];
        final String clientId;
        if (clientField is Map) {
          clientId = clientField['_id']?.toString() ?? '';
        } else {
          clientId = clientField?.toString() ?? '';
        }

        debugPrint('[BookingRepo] booking ${booking['_id']} | clientId: $clientId | currentUserId: $currentUserId');

        if (currentUserId.isNotEmpty && clientId.isNotEmpty && clientId != currentUserId) {
          debugPrint('[BookingRepo] SKIP â€” not this user\'s booking');
          continue;
        }

        final requestId = booking['request']?.toString() ?? '';
        if (requestId.isNotEmpty) {
          try {
            final requestResult = await _api.getRequestById(requestId);
            booking['request'] = requestResult['data'];
          } catch (_) {}
        }
        final caregiverId = booking['caregiver']?.toString() ?? '';
        if (caregiverId.isNotEmpty) {
          try {
            final caregiverResult = await _api.getCaregiverById(caregiverId);
            debugPrint('CAREGIVER DATA: ${caregiverResult['data']}');
            booking['caregiver'] = caregiverResult['data'];
          } catch (_) {}
        }
        final offerId = booking['offer']?.toString() ?? '';
        if (offerId.isNotEmpty) {
          try {
            booking['offer'] = {'price': booking['price']};
          } catch (_) {}
        }

        bookings.add(BookingModelUser.fromJson(booking));
      } catch (e) {
        debugPrint('[BookingRepo] failed to parse booking: $e');
        continue;
      }
    }

    debugPrint('[BookingRepo] returning ${bookings.length} bookings to UI');
    return bookings;
  }

  Future<void> cancelBooking(String bookingId) async {
    await _api.deleteBooking(bookingId);
  }
}

