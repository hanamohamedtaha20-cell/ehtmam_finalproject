import 'package:flutter/foundation.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/task_progress_model.dart';

class TaskProgressRepo {
  final ApiService _api = ApiService();

  Future<TaskProgressData> getProgress(String bookingId) async {
    final TaskProgressData empty = TaskProgressData(
      tasks: [],
      extraTasksPendingApproval: [],
      allExtraTasks: [],
      completedCount: 0,
      totalCount: 0,
      progressPercent: 0,
      workingStatus: '',
      checkInTime: '',
      caregiverName: '',
      serviceName: '',
    );

    try {
      final raw = await _api.getTaskProgress(bookingId);

      // Response: { "data": { "progress": {...}, "completedTasks": [...],
      //   "pendingTasks": [...], "bookingInfo": {...} } }
      debugPrint('>>> REFRESH RAW KEYS: ${raw.keys.toList()}');
      final outerData = raw['data'];
      if (outerData == null) {
        debugPrint('>>> REFRESH: data field is null — returning empty');
        return empty;
      }

      final data = Map<String, dynamic>.from(outerData as Map);

      // Progress stats
      final progress = data['progress'];
      final completedCount  = progress is Map ? _toInt(progress['completedTasks']) : 0;
      final totalCount      = progress is Map ? _toInt(progress['totalTasks'])     : 0;
      final progressPercent = progress is Map ? _toInt(progress['percentage'])     : 0;

      // Booking info
      final info = data['bookingInfo'];
      final workingStatus = _str(info is Map ? info['workingStatus'] : data['workingStatus']);
      final rawCheckIn    = info is Map ? info['checkInTime']  : data['checkInTime'];
      final checkInTime   = _formatIso(rawCheckIn?.toString() ?? '');
      final caregiverName = _str(info is Map ? info['caregiverName'] : data['caregiverName']);
      final serviceName   = _str(info is Map ? info['serviceName']   : data['serviceName']);

      // Tasks — completed first
      final rawCompleted = data['completedTasks'];
      final rawPending   = data['pendingTasks'];

      final completed = rawCompleted is List
          ? rawCompleted
              .whereType<Map<String, dynamic>>()
              .map(TaskProgressModel.fromCompleted)
              .toList()
          : <TaskProgressModel>[];

      // Separate caregiver extra tasks (non-rejected) from regular pending tasks.
      final List<ExtraTaskModel> allExtraTasks = [];
      final List<ExtraTaskModel> pendingExtras = [];
      final List<TaskProgressModel> pending    = [];

      debugPrint('>>> REFRESH pendingTasks count: ${rawPending is List ? rawPending.length : 0}');

      if (rawPending is List) {
        for (final item in rawPending) {
          if (item is! Map<String, dynamic>) continue;
          final createdBy = item['createdBy']?.toString() ?? '';
          final taskState = item['taskState']?.toString() ??
              item['status']?.toString() ??
              item['taskStatus']?.toString() ??
              '';
          final taskId    = item['_id']?.toString() ?? item['taskId']?.toString() ?? '';

          debugPrint('TASK_STATUS: $taskState  TASK_ID: $taskId  createdBy: $createdBy');

          if (createdBy == 'caregiver') {
            // Rejected extra tasks are completely hidden from the client view
            if (taskState.toLowerCase() == 'rejected') continue;

            final extra = ExtraTaskModel.fromJson(item);
            allExtraTasks.add(extra);
            if (extra.isPendingApproval) {
              pendingExtras.add(extra);
            }
          } else {
            pending.add(TaskProgressModel.fromPending(item));
          }
        }
      }

      debugPrint('>>> REFRESH extra tasks total=${allExtraTasks.length} pending=${pendingExtras.length}');
      for (final t in allExtraTasks) {
        debugPrint('TASK_ID: ${t.id}  TASK_STATE: ${t.taskState}  isPending: ${t.isPendingApproval}  isApproved: ${t.isApproved}');
      }

      return TaskProgressData(
        tasks: [...completed, ...pending],
        extraTasksPendingApproval: pendingExtras,
        allExtraTasks: allExtraTasks,
        completedCount: completedCount,
        totalCount: totalCount,
        progressPercent: progressPercent,
        workingStatus: workingStatus,
        checkInTime: checkInTime,
        caregiverName: caregiverName,
        serviceName: serviceName,
      );
    } catch (e, st) {
      debugPrint('>>> REFRESH ERROR: $e');
      debugPrint('>>> REFRESH STACKTRACE: $st');
      return empty;
    }
  }

  static int _toInt(dynamic v) => v == null ? 0 : (v as num).toInt();

  static String _str(dynamic v) => v?.toString() ?? '';

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
