import '../model/rating_model.dart';

class RatingRepo {
  Future<void> submitRating(RatingModel model) async {
    await Future.delayed(const Duration(seconds: 1));

    // هنا تحطي API
    print("Rating Submitted: ${model.overall}");
  }
}