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
  final String profilePicture;
  final String experience;
  final String price;

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
    this.profilePicture = '',
    this.experience = '',
    this.price = '',
  });

  factory CaregiverModel.fromApiData({
    required Map<String, dynamic> profile,
    Map<String, dynamic>? wallet,
    List<Map<String, dynamic>> reviewsList = const [],
    int completedBookingsCount = 0,
    String govFallback = '',
    String phoneFallback = '',
    String profilePictureUrl = '',
  }) {
    final addr = profile['address'] is Map
        ? profile['address'] as Map
        : <dynamic, dynamic>{};
    final location = addr['governorate']?.toString() ??
        addr['government']?.toString() ??
        profile['governorate']?.toString() ??
        profile['government']?.toString() ??
        govFallback;

    // Rating: prefer profile fields; fall back to computing from reviews list
    final reviewCount = ((profile['totalReviewsCount'] ??
            profile['reviewsCount'] ??
            profile['numReviews'] ??
            reviewsList.length) as num)
        .toInt();

    double avgRating = ((profile['averageRating'] ??
            profile['avgRating'] ??
            profile['rating'] ??
            0) as num)
        .toDouble();
    if (avgRating == 0 && reviewsList.isNotEmpty) {
      final sum = reviewsList.fold<double>(
        0,
        (acc, r) =>
            acc +
            ((r['overallRating'] ?? r['rating'] ?? 0) as num).toDouble(),
      );
      avgRating = sum / reviewsList.length;
    }

    // totalRequests: prefer real completed bookings count from repo
    final totalRequests = completedBookingsCount > 0
        ? completedBookingsCount
        : ((profile['totalBookings'] ??
                profile['totalRequests'] ??
                0) as num)
            .toInt();

    final totalEarnings = wallet != null
        ? ((wallet['totalEarned'] ?? 0) as num).toDouble()
        : 0.0;

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
      rating: avgRating,
      reviews: reviewCount,
      totalRequests: totalRequests,
      totalEarnings: totalEarnings,
      completionRate:
          ((profile['completionRate'] ?? 0) as num).toDouble(),
      avgResponse: profile['avgResponse']?.toString() ?? '—',
      profilePicture: profilePictureUrl.isNotEmpty
          ? profilePictureUrl
          : (profile['profile_picture']?.toString() ??
              profile['profilePicture']?.toString() ??
              profile['avatar']?.toString() ??
              ''),
      experience: profile['experience']?.toString() ?? '',
      price: profile['price']?.toString() ?? '',
    );
  }

  factory CaregiverModel.fromPrefs({
    required String name,
    required String email,
    required String phone,
    required String location,
    required String specialty,
    String profilePicture = '',
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
      profilePicture: profilePicture,
    );
  }
}
