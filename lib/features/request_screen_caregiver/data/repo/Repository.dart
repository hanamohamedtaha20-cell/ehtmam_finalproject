import '../model/care_request.dart';

abstract class CareRequestsRepository {
  Future<List<CareRequestModel>> getAllRequests();
  Future<void> respondToRequest({
    required String requestId,
    required String action,
  });
}
