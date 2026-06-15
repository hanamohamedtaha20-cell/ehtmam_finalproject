import '../../../../core/network/api_service.dart';
import '../model/model.dart';

class RequestsRepo {
  final ApiService apiService;

  RequestsRepo(this.apiService);

  Future<List<RequestModel>> getRequests() async {
    final response = await apiService.getMyRequests();

    print("MY REQUESTS RESPONSE => $response");

    final List data = response['data'] ?? [];

    final rawItems = data.cast<Map<String, dynamic>>();
    final results = List<RequestModel>.from(
      rawItems.map((item) => RequestModel.fromJson(item)),
    );

    await Future.wait(
      List.generate(rawItems.length, (i) async {
        try {
          final offersResponse =
              await apiService.getOffersOnRequest(results[i].id);
          final offersList = offersResponse['data'];
          final count = offersList is List ? offersList.length : 0;
          results[i] = RequestModel.fromJsonWithOffersCount(rawItems[i], count);
        } catch (_) {}
      }),
    );

    return results;
  }
}