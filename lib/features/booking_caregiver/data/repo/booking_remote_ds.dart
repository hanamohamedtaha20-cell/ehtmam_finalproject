import 'package:flutter/foundation.dart';
import '../../../../core/network/api_service.dart';
import '../model/booking_details_model.dart';

abstract class BookingRemoteDatasource {
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
      final rawProfile = response['data'];
      final profile = rawProfile is Map<String, dynamic> ? rawProfile : <String, dynamic>{};
      final address = profile['address'] is Map ? profile['address'] as Map : <String, dynamic>{};

      final picture = profile['profile_picture']?.toString() ??
          profile['profilePicture']?.toString() ??
          profile['avatar']?.toString() ??
          '';
      final rating = ((profile['rating'] ?? profile['averageRating'] ?? 0) as num).toDouble();

      debugPrint('[ClientProfile] profile_picture=$picture');
      debugPrint('[ClientProfile] rating=$rating');
      debugPrint('[ClientProfile] full profile keys=${profile.keys.toList()}');

      return details.copyWith(
        clientName: profile['full_name']?.toString() ?? details.clientName,
        phone: profile['phoneNumber']?.toString() ??
            profile['phone']?.toString() ??
            profile['phone_number']?.toString() ??
            details.phone,
        email: profile['email']?.toString() ?? details.email,
        street: address['street']?.toString() ?? details.street,
        building: address['building']?.toString() ?? details.building,
        clientProfilePicture: picture.isNotEmpty ? picture : details.clientProfilePicture,
        rating: rating > 0 ? rating : details.rating,
      );
    } catch (_) {
      return details;
    }
  }

  @override
  Future<BookingDetailsModel> getBookingDetails(String bookingId) async {
    final response = await apiService.getBookingById(bookingId);
    final raw = response['data'];
    final data = raw is Map<String, dynamic> ? raw : (raw is List && raw.isNotEmpty ? raw.first as Map<String, dynamic> : <String, dynamic>{});
    var details = BookingDetailsModel.fromBookingJson(data);
    return _enrichWithClientProfile(details, data);
  }

  @override
  Future<BookingDetailsModel> getRequestDetails(String requestId) async {
    final response = await apiService.getRequestById(requestId);
    final raw = response['data'];
    final data = raw is Map<String, dynamic> ? raw : (raw is List && raw.isNotEmpty ? raw.first as Map<String, dynamic> : <String, dynamic>{});
    var details = BookingDetailsModel.fromRequestJson(data);
    return _enrichWithClientProfile(details, data);
  }

  @override
  Future<List<TaskModel>> getTasks(String requestId) async {
    final list = await apiService.getTasksByRequestId(requestId);
    return list.asMap().entries.map((entry) {
      return TaskModel.fromJson(
        entry.value as Map<String, dynamic>,
        index: entry.key,
      );
    }).toList();
  }

  @override
  Future<List<TaskModel>> getTasksByBookingId(String bookingId) async {
    final list = await apiService.getTasksByBookingId(bookingId);
    return list.asMap().entries.map((entry) {
      return TaskModel.fromJson(
        entry.value as Map<String, dynamic>,
        index: entry.key,
      );
    }).toList();
  }

  @override
  Future<void> updateTask(String taskId, bool completed) async {
    await apiService.updateTask(
      id: taskId,
      taskState: completed ? 'completed' : 'pending',
    );
  }

  @override
  Future<Map<String, dynamic>> sendOffer({
    required String requestId,
    required num price,
    String? notes,
  }) async {
    debugPrint('SENDING OFFER: requestId=$requestId, price=$price');
    final response = await apiService.sendOffer(
      requestId: requestId,
      price: price,
      notes: notes,
    );
    debugPrint('OFFER RESPONSE: $response');
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    throw Exception(
      response['message']?.toString() ?? 'Failed to send offer',
    );
  }}

