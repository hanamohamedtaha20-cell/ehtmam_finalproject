class RatingModel {
  final String clientName;
  final String clientRole;
  final String? clientAvatarUrl;
  final int overallRating;
  final int communication;
  final int easeOfUse;
  final int reliability;
  final int overallSatisfaction;
  final String? reviewText;

  const RatingModel({
    required this.clientName,
    required this.clientRole,
    this.clientAvatarUrl,
    required this.overallRating,
    required this.communication,
    required this.easeOfUse,
    required this.reliability,
    required this.overallSatisfaction,
    this.reviewText,
  });

  RatingModel copyWith({
    int? overallRating,
    int? communication,
    int? easeOfUse,
    int? reliability,
    int? overallSatisfaction,
    String? reviewText,
  }) {
    return RatingModel(
      clientName: clientName,
      clientRole: clientRole,
      clientAvatarUrl: clientAvatarUrl,
      overallRating: overallRating ?? this.overallRating,
      communication: communication ?? this.communication,
      easeOfUse: easeOfUse ?? this.easeOfUse,
      reliability: reliability ?? this.reliability,
      overallSatisfaction: overallSatisfaction ?? this.overallSatisfaction,
      reviewText: reviewText ?? this.reviewText,
    );
  }
}