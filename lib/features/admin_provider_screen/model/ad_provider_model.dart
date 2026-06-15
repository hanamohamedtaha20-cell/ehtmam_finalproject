class AdProviderModel {
  final String id;
  final String name;
  final String email;
  final String service;

  final double rating;
  final int reviews;

  final bool isVerified;
  final bool isActive;

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
    required this.isActive,
    required this.status,
    required this.profilePicture,
  });

  factory AdProviderModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AdProviderModel(
      id: json['_id']?.toString() ?? '',

      name: json['full_name']?.toString() ?? '',

      email: json['email']?.toString() ?? '',

      service: json['specialty']?.toString() ?? '',

      rating:
      (json['averageRating'] ?? 0)
          .toDouble(),

      reviews:
      json['totalReviewsCount'] ?? 0,

      isVerified:
      (json['status']?.toString() ?? '') ==
          'Approved',

      isActive:
      json['active'] ?? false,

      status:
      json['status']?.toString() ?? '',

      profilePicture:
      json['profile_picture']?.toString() ?? '',
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
    bool? isActive,
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
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      profilePicture:
      profilePicture ?? this.profilePicture,
    );
  }
}