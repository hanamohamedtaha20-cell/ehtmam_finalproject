import '../model/reviews_data.dart';

class ReviewRepository {
  Future<List<ReviewModel>> getReviews() async {
    await Future.delayed(Duration(seconds: 1)); // simulate loading

    return [
      ReviewModel(
        name: "ahmed amer",
        date: "March 10, 2026",
        rating: 5,
        review: "Sarah was amazing!",
      ),
      ReviewModel(
        name: "mina mustafa",
        date: "March 5, 2026",
        rating: 5,
        review: "Very professional!",
      ),
      ReviewModel(
        name: "mina mustafa",
        date: "March 5, 2026",
        rating: 5,
        review: "Very professional!",
      ),
    ];
  }
}