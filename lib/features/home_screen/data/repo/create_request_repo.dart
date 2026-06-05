import '../model/create_request_model.dart';
import '../services/create_request_api_service.dart';

class CreateRequestRepo {
  final CreateRequestApiService apiService;

  CreateRequestRepo(this.apiService);

  Future<void> createRequest(CreateRequestModel model) async {
    await apiService.createRequest(
      model.toJson(),
    );
  }
}