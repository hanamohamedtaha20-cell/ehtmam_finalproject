import 'package:ehtemam_final_project/features/admin_home_screen/model/quick_action_model.dart';

import 'activity_model.dart';

class DashboardModel {
  final String appName;
  final String date;

  final List<ActivityModel> activities;
  final List<QuickActionModel> quickActions;

  DashboardModel({
    required this.appName,
    required this.date,
    required this.activities,
    required this.quickActions,
  });

  factory DashboardModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DashboardModel(
      appName: json['app_name']?.toString() ?? '',
      date: json['date']?.toString() ?? '',

      activities: (json['activities'] as List?)
          ?.map(
            (e) => ActivityModel.fromJson(e),
      )
          .toList() ??
          [],

      quickActions: (json['quick_actions'] as List?)
          ?.map(
            (e) => QuickActionModel.fromJson(e),
      )
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_name': appName,
      'date': date,
      'activities':
      activities.map((e) => e.toJson()).toList(),
      'quick_actions':
      quickActions.map((e) => e.toJson()).toList(),
    };
  }
}