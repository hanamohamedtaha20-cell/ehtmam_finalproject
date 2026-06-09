import '../../../../core/network/api_service.dart';
import '../model/booking_details_model.dart';

abstract class BookingRemoteDatasource {
  Future<BookingDetailsModel> getBookingDetails(String bookingId);
  Future<BookingDetailsModel> getRequestDetails(String requestId);
  Future<List<TaskModel>> getTasks();
  Future<void> updateTask(String taskId, bool completed);
  Future<void> sendOffer({
    required String requestId,
    required num price,
    String? notes,
  });
}

class BookingRemoteDataSourceImpl implements BookingRemoteDatasource {
  final ApiService apiService;

  BookingRemoteDataSourceImpl(this.apiService);

  Future<BookingDetailsModel> _enrichWithClientProfile(
    BookingDetailsModel details,
    Map<String, dynamic> rawData,
  ) async {
    final clientField = rawData['client'] ??
        (rawData['request'] is Map ? rawData['request']['client'] : null);

    if (clientField is! String || clientField.isEmpty) {
      return details;
    }

    try {
      final response = await apiService.getUserProfile(clientField);
      final profile = response['data'] as Map<String, dynamic>? ?? {};
      return details.copyWith(
        clientName: profile['full_name']?.toString() ?? details.clientName,
        phone: profile['phone']?.toString() ?? details.phone,
        email: profile['email']?.toString() ?? details.email,
      );
    } catch (_) {
      return details;
    }
  }

  @override
  Future<BookingDetailsModel> getBookingDetails(String bookingId) async {
    final response = await apiService.getBookingById(bookingId);
    final data = response['data'] as Map<String, dynamic>? ?? {};
    var details = BookingDetailsModel.fromBookingJson(data);
    return _enrichWithClientProfile(details, data);
  }

  @override
  Future<BookingDetailsModel> getRequestDetails(String requestId) async {
    final response = await apiService.getRequestById(requestId);
    final data = response['data'] as Map<String, dynamic>? ?? {};
    var details = BookingDetailsModel.fromRequestJson(data);
    return _enrichWithClientProfile(details, data);
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    final response = await apiService.getAllTasks();
    final list = response['data'] as List? ?? [];
    return list
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> updateTask(String taskId, bool completed) async {
    await apiService.updateTask(
      id: taskId,
      taskState: completed ? 'completed' : 'pending',
    );
  }

  @override
  Future<void> sendOffer({
    required String requestId,
    required num price,
    String? notes,
  }) async {
    await apiService.sendOffer(
      requestId: requestId,
      price: price,
      notes: notes,
    );
  }
}
