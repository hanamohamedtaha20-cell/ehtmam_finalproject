import '../../../../core/network/api_service.dart';

abstract class RatingRepo {
  Future<void> submitRating({
    required String bookingId,
    required int overallRating,
    required int professionalismRating,
    required int serviceQualityRating,
    required int punctualityRating,
    required int communicationRating,
    required String reviewComment,
  });
}

class RatingRepoImpl implements RatingRepo {
  final ApiService _api;
  RatingRepoImpl([ApiService? api]) : _api = api ?? ApiService();

  @override
  Future<void> submitRating({
    required String bookingId,
    required int overallRating,
    required int professionalismRating,
    required int serviceQualityRating,
    required int punctualityRating,
    required int communicationRating,
    required String reviewComment,
  }) async {
    await _api.createReview(
      bookingId: bookingId,
      overallRating: overallRating,
      professionalismRating: professionalismRating,
      serviceQualityRating: serviceQualityRating,
      punctualityRating: punctualityRating,
      communicationRating: communicationRating,
      reviewComment: reviewComment,
    );
  }
}
