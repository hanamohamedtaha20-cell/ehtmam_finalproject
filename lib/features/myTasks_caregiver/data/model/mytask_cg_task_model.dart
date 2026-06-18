class MytaskCgTaskModel {
  final String id;
  final String title;
  final String description;
  final String status;        // "Pending" | "Completed"
  final String assignedTo;
  final String category;
  final String date;
  final String checkInTime;   // formatted "h:mm AM/PM" from task response
  final String checkOutTime;  // formatted "h:mm AM/PM" from task response
  final String taskType;      // "daily", "weekly", etc.
  final List<String> mediaProof;
  final bool isDone;
  final bool isAddedByCaregiver;

  MytaskCgTaskModel({
    required this.id,
    required this.title,
    this.description = '',
    this.status = 'Pending',
    required this.assignedTo,
    required this.category,
    required this.date,
    this.checkInTime = '',
    this.checkOutTime = '',
    this.taskType = '',
    this.mediaProof = const [],
    this.isDone = false,
    this.isAddedByCaregiver = false,
  });

  factory MytaskCgTaskModel.fromJson(
    Map<String, dynamic> json, {
    String category = '',
    String clientName = '',
  }) {
    final statusStr =
        (json['taskState'] ?? json['taskStatus'] ?? json['done'] ?? 'pending')
            .toString()
            .toLowerCase();
    final isDone = statusStr == 'completed' || statusStr == 'true';

    // Parse proofFiles array: [{ "url": "...", "fileType": "image", ... }]
    List<String> mediaProof = [];
    final proofFiles = json['proofFiles'];
    if (proofFiles is List) {
      mediaProof = proofFiles
          .whereType<Map>()
          .map((f) => f['url']?.toString() ?? '')
          .where((url) => url.isNotEmpty)
          .toList();
    }
    if (mediaProof.isEmpty) {
      final proofUrl = json['proofUrl']?.toString() ?? '';
      if (proofUrl.isNotEmpty) mediaProof = [proofUrl];
    }

    final rawIn  = json['checkInTime']?.toString()  ?? '';
    final rawOut = json['checkOutTime']?.toString() ?? '';

    return MytaskCgTaskModel(
      id: json['_id']?.toString() ?? json['taskId']?.toString() ?? '',
      title: json['taskName']?.toString() ??
          json['taskTitle']?.toString() ??
          json['title']?.toString() ??
          json['taskDescription']?.toString() ??
          '',
      description: json['taskDescription']?.toString() ?? '',
      status: isDone ? 'Completed' : 'Pending',
      assignedTo: clientName,
      category: category,
      date: _parseDate(json),
      checkInTime:  rawIn.isNotEmpty  ? _parseTime(rawIn)  : '',
      checkOutTime: rawOut.isNotEmpty ? _parseTime(rawOut) : '',
      taskType: json['taskType']?.toString() ?? '',
      mediaProof: mediaProof,
      isDone: isDone,
      isAddedByCaregiver: false,
    );
  }

  static String _parseDate(Map<String, dynamic> json) {
    final raw = json['createdAt']?.toString() ??
        json['created_at']?.toString() ??
        json['date']?.toString() ??
        json['requestDate']?.toString() ??
        json['updatedAt']?.toString() ??
        '';
    if (raw.isEmpty) return '';
    return raw.contains('T') ? raw.split('T').first : raw;
  }

  static String _parseTime(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final h = dt.hour;
      final displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h);
      final m = dt.minute.toString().padLeft(2, '0');
      return '$displayH:$m ${h >= 12 ? 'PM' : 'AM'}';
    } catch (_) {
      return iso;
    }
  }

  MytaskCgTaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? assignedTo,
    String? category,
    String? date,
    String? checkInTime,
    String? checkOutTime,
    String? taskType,
    List<String>? mediaProof,
    bool? isDone,
    bool? isAddedByCaregiver,
  }) {
    return MytaskCgTaskModel(
      id:                id                ?? this.id,
      title:             title             ?? this.title,
      description:       description       ?? this.description,
      status:            status            ?? this.status,
      assignedTo:        assignedTo        ?? this.assignedTo,
      category:          category          ?? this.category,
      date:              date              ?? this.date,
      checkInTime:       checkInTime       ?? this.checkInTime,
      checkOutTime:      checkOutTime      ?? this.checkOutTime,
      taskType:          taskType          ?? this.taskType,
      mediaProof:        mediaProof        ?? this.mediaProof,
      isDone:            isDone            ?? this.isDone,
      isAddedByCaregiver: isAddedByCaregiver ?? this.isAddedByCaregiver,
    );
  }
}
