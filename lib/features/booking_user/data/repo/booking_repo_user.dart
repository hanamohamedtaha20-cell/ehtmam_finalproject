import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/booking_model_user.dart';

class BookingRepoUser {
  final ApiService _api = ApiService();

  Future<List<BookingModelUser>> getBookings() async {
    final result = await _api.getMyBookings();
    final list = result['data'] as List? ?? [];
    return list.map((b) => BookingModelUser.fromJson(b)).toList();
  }
   Future<void> cancelBooking(String bookingId) async {
    await _api.deleteBooking(bookingId);
}}