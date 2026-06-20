import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_service.dart';
import '../model/care_request.dart';
import 'Repository.dart';

class CareRequestsRepositoryImpl implements CareRequestsRepository {
  final ApiService apiService;

  CareRequestsRepositoryImpl(this.apiService);

  @override
  Future<List<CareRequestModel>> getAllRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCaregiverId = prefs.getString('userId') ?? '';

    debugPrint('[ActiveBookings] currentCaregiverId: $currentCaregiverId');

    final availableResponse = await apiService.getAvailableRequests();
    final bookingsResponse = await apiService.getMyBookings();

    final availableList = _extractDataList(availableResponse);
    final bookingsList = _extractDataList(bookingsResponse);

    availableList.sort((a, b) {
      final aStr = (a as Map)['createdAt']?.toString() ?? (a)['_id']?.toString() ?? '';
      final bStr = (b as Map)['createdAt']?.toString() ?? (b)['_id']?.toString() ?? '';
      return bStr.compareTo(aStr);
    });

    final pending = availableList
        .map((e) => CareRequestModel.fromRequestJson(e as Map<String, dynamic>))
        .toList();

    debugPrint('[ActiveBookings] Total bookings before filter: ${bookingsList.length}');

    // Filter raw booking maps to only include those belonging to the current caregiver.
    final myBookingsList = bookingsList.where((booking) {
      final m = booking as Map<String, dynamic>;
      final bookingCaregiverId = _extractCaregiverId(m);

      debugPrint(
        '[ActiveBookings] booking: ${m['_id']} | caregiverId in booking: $bookingCaregiverId',
      );

      // If both IDs are known and they don't match, exclude this booking.
      if (currentCaregiverId.isNotEmpty && bookingCaregiverId.isNotEmpty) {
        return bookingCaregiverId == currentCaregiverId;
      }
      // If we can't resolve the caregiver ID from the booking, include it
      // (fail-open so a caregiver doesn't lose their own bookings).
      return true;
    }).toList();

    debugPrint('[ActiveBookings] Total bookings after filter: ${myBookingsList.length}');

    final fromBookings = (await Future.wait(myBookingsList.map((e) async {
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
              // If clientName is still empty, client field may be an ID â€” fetch profile
              if (model.clientName.isEmpty) {
                final clientField = fullData['client'] ??
                    (fullData['request'] is Map
                        ? fullData['request']['client']
                        : null);
                if (clientField is String && clientField.isNotEmpty) {
                  try {
                    final profileRes =
                        await apiService.getUserProfile(clientField);
                    final profile = profileRes['data'];
                    if (profile is Map<String, dynamic>) {
                      model = model.copyWithClientName(
                        profile['full_name']?.toString() ??
                            profile['fullName']?.toString() ??
                            '',
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
      // Show all bookings except cancelled ones.
      return r.status != 'Cancelled';
    }).toList();

    final combined = [...pending, ...fromBookings];
    // id is a MongoDB ObjectId — first 8 hex chars encode the timestamp,
    // so descending lexicographic sort gives newest-first order.
    combined.sort((a, b) => b.id.compareTo(a.id));
    return combined;
  }

  /// Extracts the caregiver/provider ID from a raw booking map.
  /// Checks multiple field names since the backend may vary.
  String _extractCaregiverId(Map<String, dynamic> m) {
    // Direct caregiver field
    final caregiverField = m['caregiver'];
    if (caregiverField is String && caregiverField.isNotEmpty) {
      return caregiverField;
    }
    if (caregiverField is Map) {
      final id = caregiverField['_id']?.toString() ?? '';
      if (id.isNotEmpty) return id;
    }

    // Direct provider field
    final providerField = m['provider'];
    if (providerField is String && providerField.isNotEmpty) {
      return providerField;
    }
    if (providerField is Map) {
      final id = providerField['_id']?.toString() ?? '';
      if (id.isNotEmpty) return id;
    }

    // Caregiver/provider nested inside the offer
    final offerField = m['offer'];
    if (offerField is Map) {
      final offerCaregiver =
          offerField['caregiver'] ?? offerField['provider'];
      if (offerCaregiver is String && offerCaregiver.isNotEmpty) {
        return offerCaregiver;
      }
      if (offerCaregiver is Map) {
        return offerCaregiver['_id']?.toString() ?? '';
      }
    }

    return '';
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

