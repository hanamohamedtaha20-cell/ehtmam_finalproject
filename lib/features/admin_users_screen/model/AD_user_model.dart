class AdUserModel {
  final String id;
  final String name;
  final String email;
  final int bookingsCount;
  final String createdAt;

  AdUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.bookingsCount,
    required this.createdAt,
  });

  factory AdUserModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AdUserModel(
      id: json['_id']?.toString() ?? '',
      name: json['full_name']?.toString() ?? 'Unknown User',
      email: json['email']?.toString() ?? '',
      bookingsCount: json['bookingsCount'] ?? 0,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}