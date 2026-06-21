class AdUserModel {
  final String id;
  final String name;
  final String email;
  final int bookingsCount;
  final String createdAt;
  final bool isBlocked;
  final String profilePicture;

  AdUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.bookingsCount,
    required this.createdAt,
    this.isBlocked = false,
    this.profilePicture = '',
  });

  AdUserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? bookingsCount,
    String? createdAt,
    bool? isBlocked,
    String? profilePicture,
  }) =>
      AdUserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        bookingsCount: bookingsCount ?? this.bookingsCount,
        createdAt: createdAt ?? this.createdAt,
        isBlocked: isBlocked ?? this.isBlocked,
        profilePicture: profilePicture ?? this.profilePicture,
      );

  factory AdUserModel.fromJson(Map<String, dynamic> json) {
    return AdUserModel(
      id: json['_id']?.toString() ?? '',
      name: json['full_name']?.toString() ?? 'Unknown User',
      email: json['email']?.toString() ?? '',
      bookingsCount: ((json['bookingsCount'] ?? 0) as num).toInt(),
      createdAt: json['createdAt']?.toString() ?? '',
      isBlocked: json['isBlocked'] == true,
      profilePicture: json['profile_picture']?.toString() ?? '',
    );
  }
}
