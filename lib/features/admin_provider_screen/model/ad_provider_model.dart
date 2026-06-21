class AdProviderModel {
  final String id;
  final String name;
  final String email;
  final String service;

  final double rating;
  final int reviews;

  final bool isVerified;
  final bool isBlocked;

  final String status;
  final String profilePicture;

  AdProviderModel({
    required this.id,
    required this.name,
    required this.email,
    required this.service,
    required this.rating,
    required this.reviews,
    required this.isVerified,
    required this.isBlocked,
    required this.status,
    required this.profilePicture,
  });

  factory AdProviderModel.fromJson(Map<String, dynamic> json) {
    return AdProviderModel(
      id: json['_id']?.toString() ?? '',

      name: json['full_name']?.toString() ?? '',

      email: json['email']?.toString() ?? '',

      service:
          json['speciality']?.toString() ?? json['specialty']?.toString() ?? '',

      rating: ((json['averageRating'] ?? 0) as num).toDouble(),

      reviews:
          ((json['bookingsCount'] ?? json['totalReviewsCount'] ?? 0) as num)
              .toInt(),

      isVerified: ['Verified', 'Approved'].contains(json['status']?.toString()),

      isBlocked: json['isBlocked'] == true,

      status: json['status']?.toString() ?? '',

      profilePicture: json['profile_picture']?.toString() ?? '',
    );
  }

  AdProviderModel copyWith({
    String? id,
    String? name,
    String? email,
    String? service,
    double? rating,
    int? reviews,
    bool? isVerified,
    bool? isBlocked,
    String? status,
    String? profilePicture,
  }) {
    return AdProviderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      service: service ?? this.service,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      isVerified: isVerified ?? this.isVerified,
      isBlocked: isBlocked ?? this.isBlocked,
      status: status ?? this.status,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
