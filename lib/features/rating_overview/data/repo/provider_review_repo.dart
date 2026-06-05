import '../model/provider_review_model.dart';

abstract class ProviderReviewRepo {
  Future<ProviderReviewSummaryModel> getSummary();
  Future<List<ProviderReviewModel>> getReviews({int? starFilter});
  Future<void> markHelpful(String reviewId);
}

class ProviderReviewRepoImpl implements ProviderReviewRepo {
  @override
  Future<ProviderReviewSummaryModel> getSummary() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ProviderReviewSummaryModel(
      averageRating: 4.4,
      totalReviews: 7,
      positivePercentage: 92,
      providerRankPercentage: 5,
      starCounts: {5: 4, 4: 2, 3: 1, 2: 0, 1: 0},
    );
  }

  @override
  Future<List<ProviderReviewModel>> getReviews({int? starFilter}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final all = _mockReviews();
    if (starFilter == null) return all;
    return all.where((r) => r.rating.round() == starFilter).toList();
  }

  @override
  Future<void> markHelpful(String reviewId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  List<ProviderReviewModel> _mockReviews() => [
        ProviderReviewModel(
          id: '1',
          reviewerName: 'Sarah Ahmed',
          serviceType: 'Pet Care',
          rating: 5,
          comment: 'Excellent service! Very professional and caring with my pet. Highly recommend!',
          date: DateTime(2026, 4, 5),
          bookingId: 'BK001',
        ),
        ProviderReviewModel(
          id: '2',
          reviewerName: 'Mina Mamdouh',
          serviceType: 'Elderly Care',
          rating: 5,
          comment: 'Amazing caregiver for my elderly mother. Patient and understanding.',
          date: DateTime(2026, 4, 3),
          bookingId: 'BK002',
        ),
        ProviderReviewModel(
          id: '3',
          reviewerName: 'Wael Ashraf',
          serviceType: 'House Cleaning',
          rating: 4,
          comment: 'Great job overall, will definitely book again!',
          date: DateTime(2026, 3, 28),
          bookingId: 'BK003',
        ),
      ];
}