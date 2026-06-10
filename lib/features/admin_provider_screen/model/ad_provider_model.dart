class AdProviderModel {
  final int id;
  final String name;
  final String email;
  final String service;

  final double rating;
  final int reviews;
  final int requests;
  final double earned;

  final bool isVerified;
  final bool isActive;

  AdProviderModel({
    required this.id,
    required this.name,
    required this.email,
    required this.service,
    required this.rating,
    required this.reviews,
    required this.requests,
    required this.earned,
    required this.isVerified,
    required this.isActive,
  });

  factory AdProviderModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AdProviderModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      service: json['service'] ?? '',

      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? 0,
      requests: json['requests'] ?? 0,
      earned: (json['earned'] ?? 0).toDouble(),

      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? true,
    );
  }

  AdProviderModel copyWith({
    int? id,
    String? name,
    String? email,
    String? service,
    double? rating,
    int? reviews,
    int? requests,
    double? earned,
    bool? isVerified,
    bool? isActive,
  }) {
    return AdProviderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      service: service ?? this.service,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      requests: requests ?? this.requests,
      earned: earned ?? this.earned,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
    );
  }
}