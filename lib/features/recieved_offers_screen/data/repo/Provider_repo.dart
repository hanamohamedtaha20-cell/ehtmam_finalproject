import '../../../../core/network/api_service.dart';
import '../model/provider_data.dart';

class ProviderRepository {
  final ApiService _apiService = ApiService();

  Future<ProviderModel> getProvider(String requestId) async {
    final response =
    await _apiService.getOffersOnRequest(requestId);

    return ProviderModel.fromJson(
      response['data'],
    );
  }
}