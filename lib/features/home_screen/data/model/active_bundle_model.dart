import 'package:flutter/foundation.dart';

class ActiveBundleModel {
  final String id;
  final String bundleId;
  final String bundleName;
  final int totalSessions;
  final int remainingSessions;
  final bool isActive;

  const ActiveBundleModel({
    required this.id,
    required this.bundleId,
    required this.bundleName,
    required this.totalSessions,
    required this.remainingSessions,
    required this.isActive,
  });

  bool get hasSessions => isActive && remainingSessions > 0;

  factory ActiveBundleModel.fromJson(Map<String, dynamic> json) {
    final bundleNested = json['bundle'];

    // `bundle` field may be a populated Map OR a plain string ObjectId.
    final name = (bundleNested is Map
            ? (bundleNested['bundle_name'] ?? bundleNested['bundleName'])
            : null)
        ?.toString() ??
        json['bundleName']?.toString() ??
        json['bundle_name']?.toString() ??
        json['name']?.toString() ??
        'Active Bundle';

    final bundleId = (bundleNested is Map
            ? bundleNested['_id']?.toString()
            : bundleNested is String && bundleNested.isNotEmpty
                ? bundleNested
                : null) ??
        json['bundleId']?.toString() ??
        json['bundle_id']?.toString() ??
        '';

    debugPrint('[ActiveBundle] bundleId=$bundleId  bundleName=$name  raw_bundle=$bundleNested');

    return ActiveBundleModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      bundleId: bundleId,
      bundleName: name,
      totalSessions: _int(
          json['totalSessions'] ?? json['total_sessions'] ?? json['sessions']),
      remainingSessions: _int(json['remainingSessions'] ??
          json['remaining_sessions'] ??
          json['sessionsLeft'] ??
          json['sessionsRemaining']),
      isActive: json['isActive'] == true ||
          json['status']?.toString().toLowerCase() == 'active',
    );
  }

  static int _int(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}
