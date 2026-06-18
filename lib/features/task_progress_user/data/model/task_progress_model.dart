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

  // From data.pendingTasks[]
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

class TaskProgressData {
  final List<TaskProgressModel> tasks;
  final int completedCount;
  final int totalCount;
  final int progressPercent;
  final String workingStatus;
  final String checkInTime;
  final String caregiverName;
  final String serviceName;

  TaskProgressData({
    required this.tasks,
    required this.completedCount,
    required this.totalCount,
    required this.progressPercent,
    required this.workingStatus,
    required this.checkInTime,
    required this.caregiverName,
    required this.serviceName,
  });
}
