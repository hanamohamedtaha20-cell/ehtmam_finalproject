import 'package:ehtemam_final_project/features/booking_caregiver/data/repo/booking_remote_ds.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/data/repo/repo.dart';
import '../model/booking_details_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDatasource datasource;

  BookingRepositoryImpl(this.datasource);

  @override
  Future<BookingDetailsModel> getBookingDetails(String bookingId) =>
      datasource.getBookingDetails(bookingId);

  @override
  Future<BookingDetailsModel> getRequestDetails(String requestId) =>
      datasource.getRequestDetails(requestId);

  @override
  Future<List<TaskModel>> getTasks(String requestId) =>
      datasource.getTasks(requestId);

  @override
  Future<List<TaskModel>> getTasksByBookingId(String bookingId) =>
      datasource.getTasksByBookingId(bookingId);

  @override
  Future<void> updateTask(String taskId, bool completed) =>
      datasource.updateTask(taskId, completed);

  @override
  Future<Map<String, dynamic>> sendOffer({
    required String requestId,
    required num price,
    String? notes,
  }) =>
      datasource.sendOffer(
        requestId: requestId,
        price: price,
        notes: notes,
      );
}
