class ComplaintDetailsModel {
  final String complaintId;
  final String clientId;
  final String clientName;
  final String clientEmail;
  final String caregiverId;
  final String caregiverName;
  final String caregiverEmail;
  final String bookingId;
  final String subject;
  final String message;
  final String complaintCategory;
  final String status;
  final String createdAt;
  final String updatedAt;

  ComplaintDetailsModel({
    required this.complaintId,
    required this.clientId,
    required this.clientName,
    required this.clientEmail,
    required this.caregiverId,
    required this.caregiverName,
    required this.caregiverEmail,
    required this.bookingId,
    required this.subject,
    required this.message,
    required this.complaintCategory,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  String get formattedCreatedAt => _fmt(createdAt);
  String get formattedUpdatedAt => _fmt(updatedAt);

  static String _fmt(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return '${dt.day}/${dt.month}/${dt.year}  '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return raw.split('T').first;
    }
  }

  factory ComplaintDetailsModel.fromJson(Map<String, dynamic> json) {
    // Response: { "status": "success", "data": { "complaint": { ... } } }
    final outer = json['data'] is Map
        ? json['data'] as Map<String, dynamic>
        : json;
    final data = outer['complaint'] is Map
        ? outer['complaint'] as Map<String, dynamic>
        : outer;

    final client = data['client'] is Map
        ? data['client'] as Map<String, dynamic>
        : <String, dynamic>{};
    final caregiver = data['caregiver'] is Map
        ? data['caregiver'] as Map<String, dynamic>
        : <String, dynamic>{};
    final booking = data['booking'] is Map
        ? data['booking'] as Map<String, dynamic>
        : <String, dynamic>{};

    return ComplaintDetailsModel(
      complaintId:       (data['complaintId'] ?? data['_id'] ?? '').toString(),
      clientId:          (client['id'] ?? client['_id'] ?? '').toString(),
      clientName:        client['name']?.toString() ?? client['full_name']?.toString() ?? '',
      clientEmail:       client['email']?.toString() ?? '',
      caregiverId:       (caregiver['id'] ?? caregiver['_id'] ?? '').toString(),
      caregiverName:     caregiver['name']?.toString() ?? caregiver['full_name']?.toString() ?? '',
      caregiverEmail:    caregiver['email']?.toString() ?? '',
      bookingId:         (booking['id'] ?? booking['_id'] ?? '').toString(),
      subject:           data['subject']?.toString() ?? '',
      message:           data['message']?.toString() ?? '',
      complaintCategory: data['complaint_category']?.toString() ?? '',
      status:            data['status']?.toString() ?? '',
      createdAt:         data['createdAt']?.toString() ?? '',
      updatedAt:         data['updatedAt']?.toString() ?? '',
    );
  }
}
