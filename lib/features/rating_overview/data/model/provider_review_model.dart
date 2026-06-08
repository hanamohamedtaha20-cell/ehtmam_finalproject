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

  factory ProviderReviewModel.fromJson(Map<String, dynamic> json) {
    return ProviderReviewModel(
      id: json['id'] as String,
      reviewerName: json['reviewer_name'] as String,
      serviceType: json['service_type'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      date: DateTime.parse(json['date'] as String),
      bookingId: json['booking_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'reviewer_name': reviewerName,
        'service_type': serviceType,
        'rating': rating,
        'comment': comment,
        'date': date.toIso8601String(),
        'booking_id': bookingId,
      };
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

  factory ProviderReviewSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProviderReviewSummaryModel(
      averageRating: (json['average_rating'] as num).toDouble(),
      totalReviews: json['total_reviews'] as int,
      positivePercentage: json['positive_percentage'] as int,
      providerRankPercentage: json['provider_rank_percentage'] as int,
      starCounts: (json['star_counts'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(int.parse(k), v as int),
      ),
    );
  }
}