import '../../../../core/network/api_service.dart';
import '../model/provider_data.dart';

class ProviderRepository {
  final ApiService _apiService = ApiService();

  Future<List<ProviderModel>> getOffers(String requestId) async {
    if (requestId.trim().isEmpty) {
      throw Exception('Request id is missing');
    }

    final response = await _apiService.getOffersOnRequest(requestId.trim());
    final status = response['status']?.toString();

    if (status != 'success') {
      throw Exception(
        response['message']?.toString() ?? 'Failed to load offers',
      );
    }

    final rawOffers = _extractOffers(response['data']);
    final offers = <ProviderModel>[];

    for (final item in rawOffers) {
      if (item is! Map) continue;

      try {
        offers.add(
          ProviderModel.fromOfferJson(Map<String, dynamic>.from(item)),
        );
      } catch (_) {
        continue;
      }
    }

    return offers;
  }

  Future<String> acceptOfferAndCreateBooking(String offerId) async {
    if (offerId.trim().isEmpty) {
      throw Exception('Offer id is missing');
    }

    await _apiService.respondToOffer(
      offerId: offerId.trim(),
      status: 'accepted',
    );

    final response = await _apiService.createBookingFromOffer(offerId.trim());
    final bookingId = _extractBookingId(response);

    if (bookingId.isEmpty) {
      throw Exception('Failed to create booking from offer');
    }

    return bookingId;
  }

  String _extractBookingId(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is Map) {
      return data['_id']?.toString() ?? data['id']?.toString() ?? '';
    }

    if (data is String) return data;

    return response['_id']?.toString() ?? '';
  }

  List<dynamic> _extractOffers(dynamic data) {
    if (data is List) return data;

    if (data is Map) {
      final nestedOffers = data['offers'];
      if (nestedOffers is List) return nestedOffers;
      return [data];
    }

    return const [];
  }
}
