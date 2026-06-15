import '../../../../core/network/api_service.dart';

abstract class RatingRepo {
  Future<void> submitRating({
    required String bookingId,
    required int rating,
    required String review,
  });
}

class RatingRepoImpl implements RatingRepo {
  final ApiService _api;
  RatingRepoImpl([ApiService? api]) : _api = api ?? ApiService();

  @override
  Future<void> submitRating({
    required String bookingId,
    required int rating,
    required String review,
  }) async {
    await _api.createReview(
      bookingId: bookingId,
      rating: rating,
      review: review,
    );
  }
}
