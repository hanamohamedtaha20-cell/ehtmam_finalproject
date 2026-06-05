import '../../data/model/reviews_data.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<ReviewModel> reviews;

  ReviewLoaded(this.reviews);
}

class ReviewError extends ReviewState {}