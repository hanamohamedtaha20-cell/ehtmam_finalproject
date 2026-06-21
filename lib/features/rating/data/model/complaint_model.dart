class ComplaintRequest {
  final String bookingId;
  final String subject;
  final String message;
  final String complaintCategory;

  ComplaintRequest({
    required this.bookingId,
    required this.subject,
    required this.message,
    required this.complaintCategory,
  });

  Map<String, dynamic> toJson() => {
    'subject': subject,
    'message': message,
    'complaint_category': complaintCategory,
  };
}

class ComplaintResponse {
  final String complaintId;
  final String subject;
  final String message;
  final String status;
  final String complaintCategory;
  final String createdAt;
  final String clientName;
  final String caregiverName;

  ComplaintResponse({
    required this.complaintId,
    required this.subject,
    required this.message,
    required this.status,
    required this.complaintCategory,
    required this.createdAt,
    required this.clientName,
    required this.caregiverName,
  });

  factory ComplaintResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final client   = data['client']   is Map ? data['client']   : {};
    final caregiver = data['caregiver'] is Map ? data['caregiver'] : {};
    return ComplaintResponse(
      complaintId:      data['complaintId']?.toString()        ?? '',
      subject:          data['subject']?.toString()            ?? '',
      message:          data['message']?.toString()            ?? '',
      status:           data['status']?.toString()             ?? '',
      complaintCategory: data['complaint_category']?.toString() ?? '',
      createdAt:        data['createdAt']?.toString()          ?? '',
      clientName:       client['name']?.toString()             ?? '',
      caregiverName:    caregiver['name']?.toString()          ?? '',
    );
  }
}
