class CaregiverModel {
  final String name;
  final String specialty;
  final String phone;
  final String email;
  final String location;
  final double rating;
  final int reviews;
  final int totalRequests;
  final double totalEarnings;
  final double completionRate;
  final String avgResponse;

  CaregiverModel({
    required this.name,
    required this.specialty,
    required this.phone,
    required this.email,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.totalRequests,
    required this.totalEarnings,
    required this.completionRate,
    required this.avgResponse,
  });

  factory CaregiverModel.fromApiData({
    required Map<String, dynamic> profile,
    Map<String, dynamic>? wallet,
    String govFallback = '',
    String phoneFallback = '',
  }) {
    final addr = profile['address'] is Map ? profile['address'] as Map : <dynamic, dynamic>{};
    final location = addr['governorate']?.toString() ??
        addr['government']?.toString() ??
        profile['governorate']?.toString() ??
        profile['government']?.toString() ??
        govFallback;

    return CaregiverModel(
      name: profile['full_name']?.toString() ?? '',
      specialty: profile['specialty']?.toString() ??
          profile['careField']?.toString() ??
          profile['speciality']?.toString() ??
          '',
      phone: profile['phoneNumber']?.toString() ??
          profile['phone']?.toString() ??
          profile['phone_number']?.toString() ??
          phoneFallback,
      email: profile['email']?.toString() ?? '',
      location: location,
      rating: ((profile['averageRating'] ?? 0) as num).toDouble(),
      reviews: ((profile['totalReviewsCount'] ?? 0) as num).toInt(),
      totalRequests: ((profile['totalBookings'] ?? profile['totalRequests'] ?? 0) as num).toInt(),
      totalEarnings: wallet != null ? ((wallet['totalEarned'] ?? 0) as num).toDouble() : 0,
      completionRate: ((profile['completionRate'] ?? 0) as num).toDouble(),
      avgResponse: profile['avgResponse']?.toString() ?? '—',
    );
  }

  factory CaregiverModel.fromPrefs({
    required String name,
    required String email,
    required String phone,
    required String location,
    required String specialty,
  }) {
    return CaregiverModel(
      name: name,
      specialty: specialty,
      phone: phone,
      email: email,
      location: location,
      rating: 0,
      reviews: 0,
      totalRequests: 0,
      totalEarnings: 0,
      completionRate: 0,
      avgResponse: '—',
    );
  }
}
