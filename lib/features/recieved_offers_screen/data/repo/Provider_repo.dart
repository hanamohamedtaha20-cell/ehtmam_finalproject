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
