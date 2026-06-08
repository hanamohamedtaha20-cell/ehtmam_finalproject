import '../../../../core/network/api_service.dart';
import '../model/service_model.dart';

class HomeRepo {
  final ApiService apiService;

  HomeRepo(this.apiService);

  Future<List<ServiceModel>> getServices() async {
    final response = await apiService.getAllServices();
    print("SERVICES RESPONSE => ${response}");
    final List data = response['data'] ?? [];

    return data.map((item) {
      return ServiceModel.fromJson(item);
    }).toList();
  }
}