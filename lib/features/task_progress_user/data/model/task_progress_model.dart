import 'package:flutter/foundation.dart';

class TaskProgressModel {
  final String id;
  final String title;
  final bool isCompleted;
  final String completionTime;
  final List<String> mediaUrls;

  TaskProgressModel({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.completionTime,
    required this.mediaUrls,
  });

  // From data.completedTasks[]
  factory TaskProgressModel.fromCompleted(Map<String, dynamic> json) {
    final rawUrls = json['uploadedMediaUrls'] ?? json['mediaUrls'] ?? [];
    final urls = rawUrls is List
        ? rawUrls.map((u) => u.toString()).where((u) => u.isNotEmpty).toList()
        : <String>[];

    return TaskProgressModel(
      id: json['taskId']?.toString() ?? '',
      title: json['taskName']?.toString() ?? '',
      isCompleted: true,
      completionTime: _formatIso(
        json['completionTime']?.toString() ??
        json['completionTimestamp']?.toString() ??
        json['completedAt']?.toString() ?? '',
      ),
      mediaUrls: urls,
    );
  }

  // From data.pendingTasks[] — excludes extra tasks pending approval
  factory TaskProgressModel.fromPending(Map<String, dynamic> json) {
    return TaskProgressModel(
      id: json['taskId']?.toString() ?? '',
      title: json['taskName']?.toString() ?? '',
      isCompleted: false,
      completionTime: '',
      mediaUrls: [],
    );
  }

  static String _formatIso(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final h = dt.hour;
      final displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h);
      final m = dt.minute.toString().padLeft(2, '0');
      return '$displayH:$m ${h >= 12 ? 'PM' : 'AM'}';
    } catch (_) {
      return raw;
    }
  }
}

/// A caregiver-added extra task (any approval state).
class ExtraTaskModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String taskState;

  ExtraTaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.taskState,
  });

  factory ExtraTaskModel.fromJson(Map<String, dynamic> json) {
    debugPrint('[ExtraTask] raw JSON: $json');
    final id = json['_id']?.toString() ?? json['taskId']?.toString() ?? '';
    final taskState = json['taskState']?.toString() ??
        json['status']?.toString() ??
        json['taskStatus']?.toString() ??
        '';
    debugPrint('[ExtraTask] id=$id  taskState=$taskState  raw_taskState=${json['taskState']}  raw_status=${json['status']}  raw_taskStatus=${json['taskStatus']}');
    return ExtraTaskModel(
      id: id,
      title: json['taskName']?.toString() ?? json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      taskState: taskState,
    );
  }

  String get _lower => taskState.toLowerCase();

  bool get isPendingApproval =>
      _lower == 'pending client approval' ||
      _lower == 'pending_client_approval' ||
      _lower == 'pendingclientapproval';

  bool get isApproved  => _lower == 'approved';
  bool get isRejected  => _lower == 'rejected';
  bool get isCompleted => _lower == 'completed';
}

class TaskProgressData {
  final List<TaskProgressModel> tasks;
  final List<ExtraTaskModel> extraTasksPendingApproval;
  final List<ExtraTaskModel> allExtraTasks;
  final int completedCount;
  final int totalCount;
  final int progressPercent;
  final String workingStatus;
  final String checkInTime;
  final String caregiverName;
  final String serviceName;

  TaskProgressData({
    required this.tasks,
    this.extraTasksPendingApproval = const [],
    this.allExtraTasks = const [],
    required this.completedCount,
    required this.totalCount,
    required this.progressPercent,
    required this.workingStatus,
    required this.checkInTime,
    required this.caregiverName,
    required this.serviceName,
  });
}
