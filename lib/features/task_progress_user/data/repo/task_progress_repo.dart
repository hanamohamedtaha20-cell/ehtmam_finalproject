import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/task_progress_model.dart';

class TaskProgressRepo {
  final ApiService _api = ApiService();

  Future<TaskProgressData> getProgress(String bookingId) async {
    final TaskProgressData empty = TaskProgressData(
      tasks: [],
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
      final outerData = raw['data'];
      if (outerData == null) return empty;

      final data = Map<String, dynamic>.from(outerData as Map);

      // Progress stats — JSON numbers may arrive as double, so use num→int
      final progress = data['progress'];
      final completedCount = progress is Map
          ? _toInt(progress['completedTasks'])
          : 0;
      final totalCount = progress is Map
          ? _toInt(progress['totalTasks'])
          : 0;
      final progressPercent = progress is Map
          ? _toInt(progress['percentage'])
          : 0;

      // Booking info
      final info = data['bookingInfo'];
      final workingStatus = _str(info is Map ? info['workingStatus'] : data['workingStatus']);
      final rawCheckIn    = info is Map ? info['checkInTime']  : data['checkInTime'];
      final checkInTime   = _formatIso(rawCheckIn?.toString() ?? '');
      final caregiverName = _str(info is Map ? info['caregiverName'] : data['caregiverName']);
      final serviceName   = _str(info is Map ? info['serviceName']   : data['serviceName']);

      // Tasks — completed first, then pending
      final rawCompleted = data['completedTasks'];
      final rawPending   = data['pendingTasks'];

      final completed = rawCompleted is List
          ? rawCompleted
              .whereType<Map<String, dynamic>>()
              .map(TaskProgressModel.fromCompleted)
              .toList()
          : <TaskProgressModel>[];

      final pending = rawPending is List
          ? rawPending
              .whereType<Map<String, dynamic>>()
              .map(TaskProgressModel.fromPending)
              .toList()
          : <TaskProgressModel>[];

      return TaskProgressData(
        tasks: [...completed, ...pending],
        completedCount: completedCount,
        totalCount: totalCount,
        progressPercent: progressPercent,
        workingStatus: workingStatus,
        checkInTime: checkInTime,
        caregiverName: caregiverName,
        serviceName: serviceName,
      );
    } catch (_) {
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
