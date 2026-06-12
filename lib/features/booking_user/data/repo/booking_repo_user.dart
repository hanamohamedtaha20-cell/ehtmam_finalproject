import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/booking_model_user.dart';

class BookingRepoUser {
  final ApiService _api = ApiService();

  Future<List<BookingModelUser>> getBookings() async {
    final result = await _api.getMyBookings();
    final list = result['data'] as List? ?? [];

    final bookings = <BookingModelUser>[];

    for (final b in list) {
      try {
        final booking = Map<String, dynamic>.from(b);

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
            print('CAREGIVER DATA: ${caregiverResult['data']}');
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
      } catch (_) {
        continue;
      }
    }

    return bookings;
  }

  Future<void> cancelBooking(String bookingId) async {
    await _api.deleteBooking(bookingId);
  }
}