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

  AdUserModel copyWith({String? status}) => AdUserModel(
        id: id,
        name: name,
        email: email,
        bookingsCount: bookingsCount,
        createdAt: createdAt,
        status: status ?? this.status,
      );

  factory AdUserModel.fromJson(Map<String, dynamic> json) {
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
