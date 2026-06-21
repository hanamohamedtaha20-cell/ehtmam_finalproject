import '../activity_model.dart';
import '../quick_action_model.dart';

abstract class DashboardRepository {
  Future<List<ActivityModel>> getActivities();
  Future<List<QuickActionModel>> getQuickActions();
  Future<Map<String, int>> getStats();
}