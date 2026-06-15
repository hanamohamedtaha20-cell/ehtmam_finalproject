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
      rating:    model.overall,
      review:    model.review,
      feedback:  'Professionalism: ${model.professionalism}, '
                 'Service Quality: ${model.serviceQuality}, '
                 'Punctuality: ${model.punctuality}, '
                 'Communication: ${model.communication}',
    );
  }
}