import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/notification_model.dart';

class NotificationRepo {
  final ApiService _api = ApiService();

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _api.getNotifications();
    final raw = response['data'];
    final list = raw is List ? raw : [];
    final items = list.whereType<Map<String, dynamic>>().toList();
    items.sort((a, b) {
      final aStr = a['createdAt']?.toString() ?? a['_id']?.toString() ?? '';
      final bStr = b['createdAt']?.toString() ?? b['_id']?.toString() ?? '';
      return bStr.compareTo(aStr);
    });
    return items.map(NotificationModel.fromJson).toList();
  }
}
