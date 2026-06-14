import '../ad_provider_model.dart';

abstract class AdProviderRepository {
  Future<List<AdProviderModel>> getProviders();

  Future<void> blockProvider(String providerId);

}