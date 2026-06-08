import '../../../../core/network/api_service.dart';
import '../model/model.dart';

class RequestsRepo {
  final ApiService apiService;

  RequestsRepo(this.apiService);

  Future<List<RequestModel>> getRequests() async {
    final response = await apiService.getMyRequests();

    print("MY REQUESTS RESPONSE => $response");

    final List data = response['data'] ?? [];

    return data.map((item) {
      return RequestModel.fromJson(item);
    }).toList();
  }
}