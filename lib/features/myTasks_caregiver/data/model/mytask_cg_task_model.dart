class MytaskCgTaskModel {
  final String id;
  final String title;
  final String description;
  final String status;        // display: "Pending" | "Completed" | "Pending Approval" | "Rejected" | "Approved"
  final String taskState;     // raw from backend: "Pending", "Completed", "Pending Client Approval", "Approved", "Rejected"
  final String assignedTo;
  final String category;
  final String date;
  final String checkInTime;
  final String checkOutTime;
  final String taskType;
  final List<String> mediaProof;
  final bool isDone;
  final bool isAddedByCaregiver;
  final double price;
  final String createdBy;

  MytaskCgTaskModel({
    required this.id,
    required this.title,
    this.description = '',
    this.status = 'Pending',
    this.taskState = '',
    required this.assignedTo,
    required this.category,
    required this.date,
    this.checkInTime = '',
    this.checkOutTime = '',
    this.taskType = '',
    this.mediaProof = const [],
    this.isDone = false,
    this.isAddedByCaregiver = false,
    this.price = 0,
    this.createdBy = '',
  });

  factory MytaskCgTaskModel.fromJson(
    Map<String, dynamic> json, {
    String category = '',
    String clientName = '',
  }) {
    final rawState =
        (json['taskState'] ?? json['taskStatus'] ?? json['done'] ?? 'pending')
            .toString();
    final isDone = rawState.toLowerCase() == 'completed' || rawState == 'true';

    String displayStatus;
    switch (rawState) {
      case 'Completed':
        displayStatus = 'Completed';
        break;
      case 'Pending Client Approval':
        displayStatus = 'Pending Approval';
        break;
      case 'Rejected':
        displayStatus = 'Rejected';
        break;
      case 'Approved':
        displayStatus = 'Approved';
        break;
      default:
        displayStatus = isDone ? 'Completed' : 'Pending';
    }

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

    final createdBy = json['createdBy']?.toString() ?? '';

    return MytaskCgTaskModel(
      id: json['_id']?.toString() ?? json['taskId']?.toString() ?? '',
      title: json['taskName']?.toString() ??
          json['taskTitle']?.toString() ??
          json['title']?.toString() ??
          json['taskDescription']?.toString() ??
          '',
      description: json['taskDescription']?.toString() ??
          json['description']?.toString() ??
          '',
      status: displayStatus,
      taskState: rawState,
      assignedTo: clientName,
      category: category,
      date: _parseDate(json),
      checkInTime:  rawIn.isNotEmpty  ? _parseTime(rawIn)  : '',
      checkOutTime: rawOut.isNotEmpty ? _parseTime(rawOut) : '',
      taskType: json['taskType']?.toString() ?? '',
      mediaProof: mediaProof,
      isDone: isDone,
      isAddedByCaregiver: createdBy == 'caregiver',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      createdBy: createdBy,
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
    String? taskState,
    String? assignedTo,
    String? category,
    String? date,
    String? checkInTime,
    String? checkOutTime,
    String? taskType,
    List<String>? mediaProof,
    bool? isDone,
    bool? isAddedByCaregiver,
    double? price,
    String? createdBy,
  }) {
    return MytaskCgTaskModel(
      id:                 id                ?? this.id,
      title:              title             ?? this.title,
      description:        description       ?? this.description,
      status:             status            ?? this.status,
      taskState:          taskState         ?? this.taskState,
      assignedTo:         assignedTo        ?? this.assignedTo,
      category:           category          ?? this.category,
      date:               date              ?? this.date,
      checkInTime:        checkInTime       ?? this.checkInTime,
      checkOutTime:       checkOutTime      ?? this.checkOutTime,
      taskType:           taskType          ?? this.taskType,
      mediaProof:         mediaProof        ?? this.mediaProof,
      isDone:             isDone            ?? this.isDone,
      isAddedByCaregiver: isAddedByCaregiver ?? this.isAddedByCaregiver,
      price:              price             ?? this.price,
      createdBy:          createdBy         ?? this.createdBy,
    );
  }
}
