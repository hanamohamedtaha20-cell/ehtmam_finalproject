import 'package:flutter/material.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';

import '../activity_model.dart';
import '../quick_action_model.dart';
import 'dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final ApiService _api = ApiService();

  @override
  Future<List<ActivityModel>> getActivities() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      ActivityModel(
        title: 'New user registered: Fatma adel',
        time: '3 min ago',
      ),
      ActivityModel(
        title: "New provider: Sarah's Care Services",
        time: '25 min ago',
      ),
      ActivityModel(title: 'Payment received: 450', time: '1 hour ago'),
      ActivityModel(
        title: 'Request completed: Elderly Care',
        time: '2 hours ago',
      ),
    ];
  }

  @override
  Future<List<QuickActionModel>> getQuickActions() async {
    int pendingCount = 0;
    try {
      final res = await _api.getPendingCaregivers();
      final data = res['data'];
      if (data is List) pendingCount = data.length;
    } catch (_) {}

    return [
      QuickActionModel(
        title: 'Pending Approvals',
        icon: Icons.check_circle,
        badgeCount: pendingCount > 0 ? pendingCount : null,
      ),
      QuickActionModel(title: 'Manage Bundles', icon: Icons.inventory_2),
      QuickActionModel(title: 'Manage Complaints', icon: Icons.warning),
      QuickActionModel(title: 'View Transactions', icon: Icons.credit_card),
    ];
  }

  @override
  Future<Map<String, int>> getStats() async {
    final response = await _api.getDashboardStats();

    final data = response['data'] ?? {};

    return {
      'totalUsers': data['totalUsers'] ?? 0,
      'totalProviders': data['totalProviders'] ?? 0,
      'activeBookings': data['activeBookings'] ?? 0,
    };
  }
}
