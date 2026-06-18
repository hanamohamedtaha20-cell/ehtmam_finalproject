class AdUserModel {
  final String id;
  final String name;
  final String email;
  final int bookingsCount;
  final String createdAt;
  final String status;

  AdUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.bookingsCount,
    required this.createdAt,
    this.status = 'active',
  });

  bool get isBlocked => status == 'blocked';

  factory AdUserModel.fromJson(Map<String, dynamic> json) {
    // API may return status as 'blocked'/'active' or isActive: false
    String status = 'active';
    if (json['status'] != null) {
      status = json['status'].toString().toLowerCase();
    } else if (json['isActive'] == false) {
      status = 'blocked';
    } else if (json['isBlocked'] == true) {
      status = 'blocked';
    }

    return AdUserModel(
      id: json['_id']?.toString() ?? '',
      name: json['full_name']?.toString() ?? 'Unknown User',
      email: json['email']?.toString() ?? '',
      bookingsCount: json['bookingsCount'] ?? 0,
      createdAt: json['createdAt']?.toString() ?? '',
      status: status,
    );
  }
}
