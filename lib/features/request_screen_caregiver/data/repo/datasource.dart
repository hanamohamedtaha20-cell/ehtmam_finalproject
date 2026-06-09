import '../../../../core/network/api_service.dart';
import '../model/care_request.dart';

class CareRequestsRemoteDatasource {
  final ApiService apiService;

  CareRequestsRemoteDatasource(this.apiService);

  Future<List<CareRequestModel>> getAvailableRequests() async {
    final response = await apiService.getAvailableRequests();
    final list = response['data'] as List? ?? [];
    return list
        .map((e) =>
            CareRequestModel.fromRequestJson(e as Map<String, dynamic>))
        .toList();
  }
}
