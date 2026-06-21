import '../../../../core/network/api_service.dart';
import '../ad_provider_model.dart';
import 'ad_provider_repo.dart';

class AdProviderRepositoryImpl
    implements AdProviderRepository {

  final ApiService apiService;

  AdProviderRepositoryImpl(
      this.apiService,
      );

  @override
  Future<List<AdProviderModel>> getProviders() async {
    final response = await apiService.getAllProviders();

    // Try every common shape the backend might return:
    // { data: [...] }  |  { data: { caregivers: [...] } }  |  { caregivers: [...] }  |  [...]
    final raw = _extractList(response);

    return raw
        .whereType<Map>()
        .map((e) => AdProviderModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  List _extractList(Map<String, dynamic> response) {
    for (final key in ['data', 'caregivers', 'result', 'results']) {
      final val = response[key];
      if (val is List) return val;
      if (val is Map) {
        for (final inner in ['caregivers', 'data', 'result', 'results']) {
          if (val[inner] is List) return val[inner] as List;
        }
      }
    }
    // If the whole response is just a list wrapped by getAllProviders()
    final direct = response['data'];
    if (direct is List) return direct;
    return [];
  }

  @override
  Future<void> blockProvider(
      String providerId,
      ) async {
    await apiService.blockProvider(
      providerId,
    );
  }
}