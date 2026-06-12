import '../ad_provider_model.dart';
import 'ad_provider_repo.dart';


class AdProviderRepositoryImpl
    implements AdProviderRepository {
  @override
  Future<List<AdProviderModel>> getProviders() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    return [
      AdProviderModel(
        id: 1,
        name: 'Sarah Ashraf',
        email: 'sarah@email.com',
        service: 'Elderly Care',
        rating: 4.8,
        reviews: 56,
        requests: 98,
        earned: 5680,
        isVerified: true,
        isActive: true,
      ),
      AdProviderModel(
        id: 2,
        name: 'Menna Mamdouh',
        email: 'menna@email.com',
        service: 'Child Care',
        rating: 4.8,
        reviews: 34,
        requests: 67,
        earned: 3400,
        isVerified: true,
        isActive: true,
      ),
    ];
  }

  @override
  Future<void> blockProvider(
      int providerId,
      ) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
  }
}