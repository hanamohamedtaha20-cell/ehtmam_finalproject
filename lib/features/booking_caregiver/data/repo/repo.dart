import '../../data/model/booking_details_model.dart';

abstract class BookingRepository {
  Future<BookingDetailsModel> getBookingDetails(
      int bookingId,
      );
}