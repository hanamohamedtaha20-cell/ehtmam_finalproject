import 'package:flutter/material.dart';

import '../activity_model.dart';
import '../quick_action_model.dart';
import 'dashboard_repository.dart';

class DashboardRepositoryImpl
    implements DashboardRepository {
  @override
  Future<List<ActivityModel>>
  getActivities() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    return [
      ActivityModel(
        title:
        'New user registered: Fatma adel',
        time: '3 min ago',
      ),
      ActivityModel(
        title:
        'New provider: Sarah\'s Care Services',
        time: '25 min ago',
      ),
      ActivityModel(
        title:
        'Payment received: 450',
        time: '1 hour ago',
      ),
      ActivityModel(
        title:
        'Request completed: Elderly Care',
        time: '2 hours ago',
      ),
    ];
  }

  @override
  Future<List<QuickActionModel>>
  getQuickActions() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    return [
      QuickActionModel(
        title: 'Pending Approvals',
        icon: Icons.check_circle,
        badgeCount: 1,
      ),
      QuickActionModel(
        title: 'Manage Bundles',
        icon: Icons.inventory_2,
      ),
      QuickActionModel(
        title: 'Manage Complaints',
        icon: Icons.warning,
      ),
      QuickActionModel(
        title: 'View Transactions',
        icon: Icons.credit_card,
      ),
    ];
  }
}