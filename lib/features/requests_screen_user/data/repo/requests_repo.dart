import 'package:flutter/foundation.dart';
import '../../../../core/network/api_service.dart';
import '../model/model.dart';

class RequestsRepo {
  final ApiService apiService;

  RequestsRepo(this.apiService);

  Future<List<RequestModel>> getRequests() async {
    final response = await apiService.getMyRequests();

    debugPrint("MY REQUESTS RESPONSE => $response");

    final List data = response['data'] ?? [];

    final rawItems = data.cast<Map<String, dynamic>>();
    rawItems.sort((a, b) {
      final aStr = a['createdAt']?.toString() ?? a['_id']?.toString() ?? '';
      final bStr = b['createdAt']?.toString() ?? b['_id']?.toString() ?? '';
      return bStr.compareTo(aStr);
    });

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

