import '../../../../core/network/api_service.dart';
import '../model/bundels_model.dart';

class BundleRepo {
  final ApiService apiService;

  BundleRepo(this.apiService);

  Future<List<BundleModel>> getBundles() async {
    final response = await apiService.getAllBundles();
    final List data = response['data'] ?? [];

    return data
        .map((item) => BundleModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
