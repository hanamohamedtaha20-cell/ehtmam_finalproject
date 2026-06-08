import '../model/care_request.dart';

abstract class CareRequestsRepository {
  Future<List<CareRequestModel>>
  getAvailableRequests();
}