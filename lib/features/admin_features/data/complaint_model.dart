class ComplaintModel {
  final String id;
  final String userId;
  final String bookingId;
  final String clientName;
  final String clientEmail;
  final String caregiverName;
  final String caregiverEmail;
  final int bookingPrice;
  final String bookingStatus;
  final String subject;
  final String message;
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
    required this.bookingPrice,
    required this.bookingStatus,
    required this.subject,
    required this.message,
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

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    final booking =
        json['booking'] is Map ? json['booking'] as Map<String, dynamic> : <String, dynamic>{};
    final client =
        booking['client'] is Map ? booking['client'] as Map<String, dynamic> : <String, dynamic>{};
    final caregiver = booking['caregiver'] is Map
        ? booking['caregiver'] as Map<String, dynamic>
        : <String, dynamic>{};

    return ComplaintModel(
      id: json['_id']?.toString() ?? '',
      userId: json['user']?.toString() ?? '',
      bookingId: booking['_id']?.toString() ?? '',
      clientName: client['full_name']?.toString() ?? '',
      clientEmail: client['email']?.toString() ?? '',
      caregiverName: caregiver['full_name']?.toString() ?? '',
      caregiverEmail: caregiver['email']?.toString() ?? '',
      bookingPrice: _parseInt(booking['price']),
      bookingStatus: booking['bookingStatus']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}
