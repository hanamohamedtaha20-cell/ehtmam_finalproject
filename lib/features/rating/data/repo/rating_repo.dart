import 'package:ehtemam_final_project/core/network/api_service.dart';
import '../model/rating_model.dart';

class RatingRepo {
  final ApiService _api = ApiService();

  Future<void> submitRating({
    required RatingModel model,
    required String caregiverId,
    required String serviceId,
    required String requestId,
  }) async {
    await _api.createReview(
      caregiverId: caregiverId,
      serviceId:   serviceId,
      requestId:   requestId,
      rating:      model.overall,
      review:      model.review,
      feedback:    'Professionalism: ${model.professionalism}, '
                   'Service Quality: ${model.serviceQuality}, '
                   'Punctuality: ${model.punctuality}, '
                   'Communication: ${model.communication}',
    );
  }
}