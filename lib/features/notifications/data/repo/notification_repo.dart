import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/notification_model.dart';

class NotificationRepo {
  final ApiService _api = ApiService();

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _api.getNotifications();
    final raw = response['data'];
    final list = raw is List ? raw : [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(NotificationModel.fromJson)
        .toList();
  }
}
