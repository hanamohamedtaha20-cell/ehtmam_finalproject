import '../../../../core/network/api_service.dart';
import '../model/provider_data.dart';

class ProviderRepository {
  final ApiService _apiService = ApiService();

  Future<List<ProviderModel>> getOffers(String requestId) async {
    if (requestId.isEmpty) {
      throw Exception('Request id is missing');
    }

    final response = await _apiService.getOffersOnRequest(requestId);
    final status = response['status']?.toString();

    if (status != 'success') {
      throw Exception(
        response['message']?.toString() ?? 'Failed to load offers',
      );
    }

    final data = response['data'];
    if (data == null) return [];

    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => ProviderModel.fromOfferJson(
                Map<String, dynamic>.from(item),
              ))
          .toList();
    }

    if (data is Map) {
      return [
        ProviderModel.fromOfferJson(Map<String, dynamic>.from(data)),
      ];
    }

    return [];
  }
}
