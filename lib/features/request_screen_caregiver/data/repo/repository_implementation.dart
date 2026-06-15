import '../../../../core/network/api_service.dart';
import '../model/care_request.dart';
import 'Repository.dart';

class CareRequestsRepositoryImpl implements CareRequestsRepository {
  final ApiService apiService;

  CareRequestsRepositoryImpl(this.apiService);

  @override
  Future<List<CareRequestModel>> getAllRequests() async {
    final availableResponse = await apiService.getAvailableRequests();
    final bookingsResponse = await apiService.getMyBookings();

    final availableList = _extractDataList(availableResponse);
    final bookingsList = _extractDataList(bookingsResponse);

    final pending = availableList
        .map((e) => CareRequestModel.fromRequestJson(e as Map<String, dynamic>))
        .toList();

    final fromBookings = bookingsList.map((e) {
      final m = e as Map<String, dynamic>;
      print('BOOKING RAW STATUS: bookingStatus=${m['bookingStatus']} status=${m['status']}');
      return CareRequestModel.fromBookingJson(m);
    }).where((r) {
      print('BOOKING UI STATUS: ${r.status}');
      return r.status == 'Accepted' || r.status == 'Completed' || r.status == 'In Progress';
    }).toList();

    return [...pending, ...fromBookings];
  }

  List<dynamic> _extractDataList(dynamic response) {
    if (response is List) return response;
    if (response is Map) {
      final data = response['data'];
      if (data is List) return data;
    }
    return [];
  }

  @override
  Future<void> respondToRequest({
    required String requestId,
    required String action,
  }) async {
    await apiService.respondToRequest(
      requestId: requestId,
      action: action,
    );
  }
}
