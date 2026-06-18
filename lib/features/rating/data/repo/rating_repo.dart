import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/rating_model.dart';

class RatingRepo {
  final ApiService _api = ApiService();

  Future<void> submitRating({
    required RatingModel model,
    required String bookingId,
  }) async {
    await _api.createReview(
      bookingId: bookingId,
      overallRating: model.overall,
      professionalismRating: model.professionalism,
      serviceQualityRating: model.serviceQuality,
      punctualityRating: model.punctuality,
      communicationRating: model.communication,
      reviewComment: model.review,
    );
  }
}
