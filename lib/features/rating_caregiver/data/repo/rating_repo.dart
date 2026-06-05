import '../model/rating_model.dart';

abstract class RatingRepo {
  Future<void> submitRating(RatingModel model);
}

class RatingRepoImpl implements RatingRepo {
  @override
  Future<void> submitRating(RatingModel model) async {
    // TODO: replace with your actual API call
    await Future.delayed(const Duration(seconds: 1));
    // e.g. await dio.post('/ratings', data: model.toJson());
  }
}