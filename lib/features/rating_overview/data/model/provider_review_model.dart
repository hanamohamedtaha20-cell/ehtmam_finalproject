class ProviderReviewModel {
  final String id;
  final String reviewerName;
  final String? reviewerProfilePicture;
  final String serviceType;
  final double rating;
  final String comment;
  final DateTime date;
  final String? bookingId;

  const ProviderReviewModel({
    required this.id,
    required this.reviewerName,
    this.reviewerProfilePicture,
    required this.serviceType,
    required this.rating,
    required this.comment,
    required this.date,
    this.bookingId,
  });

  /// Parses a review object from GET /review/my-reviews
  /// The reviewer object contains: { _id, full_name, profile_picture }
  factory ProviderReviewModel.fromJson(Map<String, dynamic> json) {
    final reviewer = json['reviewer'];
    final reviewerName = reviewer is Map
        ? (reviewer['full_name']?.toString() ?? 'Unknown')
        : 'Unknown';
    final reviewerPicture = reviewer is Map
        ? reviewer['profile_picture']?.toString()
        : null;

    DateTime parsedDate = DateTime.now();
    final rawDate = json['createdAt']?.toString();
    if (rawDate != null) {
      try {
        parsedDate = DateTime.parse(rawDate).toLocal();
      } catch (_) {}
    }

    final booking = json['booking'];
    final bookingId = booking is Map
        ? booking['_id']?.toString()
        : booking?.toString();

    return ProviderReviewModel(
      id: json['_id']?.toString() ?? '',
      reviewerName: reviewerName,
      reviewerProfilePicture: reviewerPicture,
      serviceType: '',
      rating: (json['overallRating'] ?? 0).toDouble(),
      comment: json['reviewComment']?.toString() ?? '',
      date: parsedDate,
      bookingId: bookingId,
    );
  }
}

class ProviderReviewSummaryModel {
  final double averageRating;
  final int totalReviews;
  final int positivePercentage;
  final int providerRankPercentage;
  final Map<int, int> starCounts;

  const ProviderReviewSummaryModel({
    required this.averageRating,
    required this.totalReviews,
    required this.positivePercentage,
    required this.providerRankPercentage,
    required this.starCounts,
  });

  /// Parses from the `data` object of GET /review/my-reviews
  /// { averageRating, totalReviewsCount, ratingBreakdown: {"1":0,...} }
  factory ProviderReviewSummaryModel.fromApiData(Map<String, dynamic> data) {
    final breakdown = data['ratingBreakdown'];
    final Map<int, int> starCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    if (breakdown is Map) {
      for (int i = 1; i <= 5; i++) {
        starCounts[i] = (breakdown[i.toString()] ?? 0) as int;
      }
    }

    final total = (data['totalReviewsCount'] ?? 0) as int;
    final positiveCount = (starCounts[4] ?? 0) + (starCounts[5] ?? 0);
    final positivePercentage =
        total > 0 ? (positiveCount * 100 ~/ total) : 0;

    return ProviderReviewSummaryModel(
      averageRating: (data['averageRating'] ?? 0).toDouble(),
      totalReviews: total,
      positivePercentage: positivePercentage,
      providerRankPercentage: 0,
      starCounts: starCounts,
    );
  }
}
