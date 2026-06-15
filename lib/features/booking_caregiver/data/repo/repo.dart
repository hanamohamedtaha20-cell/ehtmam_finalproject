import '../../data/model/booking_details_model.dart';

abstract class BookingRepository {
  Future<BookingDetailsModel> getBookingDetails(String bookingId);
  Future<BookingDetailsModel> getRequestDetails(String requestId);
  Future<List<TaskModel>> getTasks(String requestId);
  Future<List<TaskModel>> getTasksByBookingId(String bookingId);
  Future<void> updateTask(String taskId, bool completed);
  Future<Map<String, dynamic>> sendOffer({
    required String requestId,
    required num price,
    String? notes,
  });
}
