class ComplaintModel {
  final String id;
  final String userId;
  final String bookingId;
  final String clientName;
  final String clientEmail;
  final String caregiverName;
  final String caregiverEmail;
  final String subject;
  final String message;
  final String complaintCategory;
  final String status;
  final String createdAt;

  ComplaintModel({
    required this.id,
    required this.userId,
    required this.bookingId,
    required this.clientName,
    required this.clientEmail,
    required this.caregiverName,
    required this.caregiverEmail,
    required this.subject,
    required this.message,
    required this.complaintCategory,
    required this.status,
    required this.createdAt,
  });

  String get formattedDate {
    if (createdAt.isEmpty) return '';
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return createdAt.split('T').first;
    }
  }

  // Response shape (admin list):
  // {
  //   "complaintId": "...",
  //   "subject": "...", "message": "...", "complaint_category": "...",
  //   "status": "...", "createdAt": "...",
  //   "client":   { "id": "...", "name": "...", "full_name": "...", "email": "..." },
  //   "caregiver":{ "id": "...", "name": "...", "full_name": "...", "email": "..." },
  //   "booking":  { "id": "..." },
  //   "user":     { "id": "...", "name": "...", "email": "..." }
  // }
  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    final client = json['client'] is Map
        ? json['client'] as Map<String, dynamic>
        : <String, dynamic>{};
    final caregiver = json['caregiver'] is Map
        ? json['caregiver'] as Map<String, dynamic>
        : <String, dynamic>{};
    final booking = json['booking'] is Map
        ? json['booking'] as Map<String, dynamic>
        : <String, dynamic>{};

    return ComplaintModel(
      id:                (json['complaintId'] ?? json['_id'] ?? '').toString(),
      userId:            (json['user'] is Map
                            ? (json['user'] as Map)['id']
                            : json['user'])
                         ?.toString() ?? '',
      bookingId:         (booking['id'] ?? booking['_id'] ?? '').toString(),
      clientName:        client['name']?.toString()
                            ?? client['full_name']?.toString() ?? '',
      clientEmail:       client['email']?.toString() ?? '',
      caregiverName:     caregiver['name']?.toString()
                            ?? caregiver['full_name']?.toString() ?? '',
      caregiverEmail:    caregiver['email']?.toString() ?? '',
      subject:           json['subject']?.toString() ?? '',
      message:           json['message']?.toString() ?? '',
      complaintCategory: json['complaint_category']?.toString() ?? '',
      status:            json['status']?.toString() ?? '',
      createdAt:         json['createdAt']?.toString() ?? '',
    );
  }
}
