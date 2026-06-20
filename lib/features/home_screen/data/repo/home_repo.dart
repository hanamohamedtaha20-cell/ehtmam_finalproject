import 'package:flutter/foundation.dart';
import '../../../../core/network/api_service.dart';
import '../model/service_model.dart';

class HomeRepo {
  final ApiService apiService;

  HomeRepo(this.apiService);

  Future<List<ServiceModel>> getServices() async {
    final response = await apiService.getAllServices();
    debugPrint("SERVICES RESPONSE => $response");

    dynamic raw = response['data'];
    if (raw is Map) raw = raw['services'] ?? raw['data'] ?? [];
    final List data = (raw is List) ? raw : [];

    debugPrint("[Services] items in response: ${data.length}");

    final List<ServiceModel> result = [];
    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      if (item == null) {
        debugPrint("[Services] item[$i] is null - skipped");
        continue;
      }
      if (item is! Map) {
        debugPrint("[Services] item[$i] skipped - not a Map (${item.runtimeType}): $item");
        continue;
      }
      try {
        final map = Map<String, dynamic>.from(item as Map);
        final model = ServiceModel.fromJson(map);
        debugPrint("[Services] [$i] id=${model.id} name='${model.name}'");
        result.add(model);
      } catch (e) {
        debugPrint("[Services] item[$i] failed to parse: $e - raw: $item");
      }
    }

    debugPrint("[Services] parsed ${result.length} of ${data.length}");
    return result;
  }
}
