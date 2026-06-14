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
  Future<List<AdProviderModel>>
  getProviders() async {

    final response =
    await apiService
        .getPendingCaregivers();

    final List caregivers =
    response['data']['caregivers'];

    return caregivers
        .map(
          (e) =>
          AdProviderModel.fromJson(e),
    )
        .toList();
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