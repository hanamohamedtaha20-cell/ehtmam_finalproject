class ReviewSummaryModel {
  final double averageRating;
  final int totalReviewsCount;
  final Map<String, int> ratingBreakdown;

  const ReviewSummaryModel({
    this.averageRating = 0.0,
    this.totalReviewsCount = 0,
    this.ratingBreakdown = const {},
  });

  factory ReviewSummaryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final breakdown = (data['ratingBreakdown'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), (v as num?)?.toInt() ?? 0),
        ) ??
        {};
    return ReviewSummaryModel(
      averageRating:    (data['averageRating']    as num?)?.toDouble() ?? 0.0,
      totalReviewsCount:(data['totalReviewsCount'] as num?)?.toInt()   ?? 0,
      ratingBreakdown:  breakdown,
    );
  }

  static ReviewSummaryModel empty() => const ReviewSummaryModel();
}
