import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_service.dart';
import '../model/provider_data.dart';
import '../../../home_screen/data/model/active_bundle_model.dart';

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

  Future<Map<String, dynamic>> acceptOffer(
      String offerId, {
        String? requestId,
      }) async {
    final trimmedOfferId = offerId.trim();
    if (trimmedOfferId.isEmpty) {
      throw Exception('Offer id is missing');
    }
    try {
      debugPrint('PROCESS PAYMENT: $trimmedOfferId');
      final response = await _apiService.processPayment(trimmedOfferId);
      debugPrint('PROCESS PAYMENT DONE: $response');
      return response;
    } catch (e) {
      debugPrint('ERROR TYPE: ${e.runtimeType}');
      debugPrint('ERROR: $e');
      rethrow;
    }
  }

  Future<String> findBookingForAcceptedOffer(
    String offerId, {
    String? requestId,
  }) async {
    try {
      return await _resolveBookingId(
        offerId: offerId.trim(),
        requestId: requestId?.trim() ?? '',
      );
    } catch (_) {
      return '';
    }
  }

  Future<String> _resolveBookingId({
    required String offerId,
    required String requestId,
  }) async {
    for (var attempt = 0; attempt < 3; attempt++) {
      final bookingId = await _lookupBookingId(
        offerId: offerId,
        requestId: requestId,
      );
      if (bookingId.isNotEmpty) return bookingId;

      if (attempt < 2) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    return _createBookingFromOffer(offerId);
  }

  Future<String> _lookupBookingId({
    required String offerId,
    required String requestId,
  }) async {
    try {
      final response = await _apiService.getMyBookings();
      final list = _extractBookingsList(response);
      String? pendingRequestMatch;

      for (final item in list) {
        if (item is! Map) continue;

        final booking = Map<String, dynamic>.from(item);
        final id = booking['_id']?.toString() ?? '';
        if (id.isEmpty) continue;

        if (_bookingMatchesOffer(booking, offerId)) return id;

        if (requestId.isNotEmpty &&
            _bookingMatchesRequest(booking, requestId)) {
          final status =
              (booking['status'] ?? booking['bookingStatus'] ?? '')
                  .toString()
                  .toUpperCase();
          if (status == 'PENDING') {
            pendingRequestMatch ??= id;
          }
        }
      }

      return pendingRequestMatch ?? '';
    } catch (_) {
      return '';
    }
  }

  Future<String> _createBookingFromOffer(String offerId) async {
    try {
      final response = await _apiService.createBookingFromOffer(offerId);
      return _extractBookingId(response);
    } catch (_) {
      return '';
    }
  }

  String _extractBookingId(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is Map) {
      return data['_id']?.toString() ?? data['id']?.toString() ?? '';
    }

    if (data is String) return data;

    return response['_id']?.toString() ?? '';
  }

  bool _bookingMatchesOffer(Map<String, dynamic> booking, String offerId) {
    final offer = booking['offer'];

    if (offer is Map) {
      return offer['_id']?.toString() == offerId;
    }

    return offer?.toString() == offerId;
  }

  bool _bookingMatchesRequest(Map<String, dynamic> booking, String requestId) {
    final request = booking['request'];

    if (request is Map) {
      return request['_id']?.toString() == requestId;
    }

    return request?.toString() == requestId;
  }

  List<dynamic> _extractBookingsList(dynamic response) {
    if (response is List) return response;

    if (response is Map) {
      final data = response['data'];
      if (data is List) return data;
      if (data is Map) {
        final nested = data['bookings'];
        if (nested is List) return nested;
      }
    }

    return const [];
  }

  /// Returns the user's active purchased bundle (with remaining sessions),
  /// or null if none exists / none has sessions left.
  Future<ActiveBundleModel?> getActiveBundle() async {
    try {
      final response = await _apiService.getMyActiveBundle();
      final data = response['data'];
      if (data == null) return null;

      final Map<String, dynamic> bundleMap;
      if (data is List) {
        if (data.isEmpty) return null;
        final active = data.firstWhere(
          (b) => b is Map && (b['isActive'] == true || b['status']?.toString().toLowerCase() == 'active'),
          orElse: () => data.first,
        );
        if (active == null) return null;
        bundleMap = Map<String, dynamic>.from(active as Map);
      } else if (data is Map) {
        bundleMap = Map<String, dynamic>.from(data);
      } else {
        return null;
      }

      final model = ActiveBundleModel.fromJson(bundleMap);
      return model.hasSessions ? model : null;
    } catch (e) {
      debugPrint('[Bundle] getActiveBundle error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> acceptOfferWithBundle(String offerId) async {
    return await _apiService.acceptOfferWithBundle(offerId);
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

