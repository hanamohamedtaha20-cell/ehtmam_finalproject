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
    final trimmedOfferId = offerId.trim();
    if (trimmedOfferId.isEmpty) {
      throw Exception('Offer id is missing');
    }

    await _apiService.respondToOffer(
      offerId: trimmedOfferId,
      status: 'accepted',
    );

    final bookingId = await _findBookingIdForOffer(trimmedOfferId);
    if (bookingId.isEmpty) {
      throw Exception('Booking was not created for this offer');
    }

    return bookingId;
  }

  Future<String> _findBookingIdForOffer(String offerId) async {
    for (var attempt = 0; attempt < 3; attempt++) {
      final bookingId = await _lookupBookingIdForOffer(offerId);
      if (bookingId.isNotEmpty) return bookingId;

      if (attempt < 2) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    return '';
  }

  Future<String> _lookupBookingIdForOffer(String offerId) async {
    final response = await _apiService.getMyBookings();
    final list = response['data'];
    if (list is! List) return '';

    for (final item in list) {
      if (item is! Map) continue;

      final booking = Map<String, dynamic>.from(item);
      if (!_bookingMatchesOffer(booking, offerId)) continue;

      return booking['_id']?.toString() ?? '';
    }

    return '';
  }

  bool _bookingMatchesOffer(Map<String, dynamic> booking, String offerId) {
    final offer = booking['offer'];

    if (offer is Map) {
      return offer['_id']?.toString() == offerId;
    }

    return offer?.toString() == offerId;
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
