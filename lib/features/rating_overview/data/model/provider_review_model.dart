class ProviderReviewModel {
  final String id;
  final String reviewerName;
  final String serviceType;
  final double rating;
  final String comment;
  final DateTime date;
  final String? bookingId;

  const ProviderReviewModel({
    required this.id,
    required this.reviewerName,
    required this.serviceType,
    required this.rating,
    required this.comment,
    required this.date,
    this.bookingId,
  });

  /// Parses a review object from GET /review/caregiver/{id}
  factory ProviderReviewModel.fromJson(Map<String, dynamic> json) {
    final client = json['client'];
    final reviewerName = client is Map
        ? (client['full_name']?.toString() ?? 'Unknown')
        : 'Unknown';

    DateTime parsedDate = DateTime.now();
    final rawDate = json['createdAt']?.toString();
    if (rawDate != null) {
      try {
        parsedDate = DateTime.parse(rawDate).toLocal();
      } catch (_) {}
    }

    return ProviderReviewModel(
      id: json['_id']?.toString() ?? '',
      reviewerName: reviewerName,
      serviceType: '',
      rating: (json['overallRating'] ?? 0).toDouble(),
      comment: json['reviewComment']?.toString() ?? '',
      date: parsedDate,
      bookingId: json['booking']?.toString(),
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

  /// Parses from the `data` object of GET /review/caregiver/{id}
  /// { averageRating, totalReviewsCount, ratingBreakdown: {"1":0,"2":0,...} }
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
