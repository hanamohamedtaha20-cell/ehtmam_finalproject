import '../../../../core/network/api_service.dart';
import '../model/care_request.dart';

class CareRequestsRemoteDatasource {
  final ApiService apiService;

  CareRequestsRemoteDatasource(
      this.apiService,
      );

  Future<List<CareRequestModel>>
  getAvailableRequests() async {

    final response =
    await apiService
        .getAvailableRequests();

    return (response['data'] as List)
        .map(
          (e) =>
          CareRequestModel.fromJson(e),
    )
        .toList();
  }
}