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

    final fromBookings = (await Future.wait(bookingsList.map((e) async {
      final m = e as Map<String, dynamic>;
      final request = m['request'];
      final service = m['service'];
      final needsFullFetch = request is! Map || service is! Map;
      if (needsFullFetch) {
        final bookingId = m['_id']?.toString() ?? '';
        if (bookingId.isNotEmpty) {
          try {
            final fullResponse = await apiService.getBookingById(bookingId);
            final raw = fullResponse['data'];
            Map<String, dynamic>? fullData;
            if (raw is Map<String, dynamic>) {
              fullData = raw;
            } else if (raw is List && raw.isNotEmpty) {
              fullData = raw.first as Map<String, dynamic>;
            }
            if (fullData != null) {
              var model = CareRequestModel.fromBookingJson(fullData);
              // If clientName is still empty, client field may be an ID — fetch profile
              if (model.clientName.isEmpty) {
                final clientField = fullData['client'] ??
                    (fullData['request'] is Map ? fullData['request']['client'] : null);
                if (clientField is String && clientField.isNotEmpty) {
                  try {
                    final profileRes = await apiService.getUserProfile(clientField);
                    final profile = profileRes['data'];
                    if (profile is Map<String, dynamic>) {
                      model = model.copyWithClientName(
                        profile['full_name']?.toString() ?? profile['fullName']?.toString() ?? '',
                      );
                    }
                  } catch (_) {}
                }
              }
              return model;
            }
          } catch (_) {}
        }
      }
      return CareRequestModel.fromBookingJson(m);
    }))).where((r) {
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
