abstract class RatingState {}

class RatingInitial extends RatingState {}

class RatingUpdated extends RatingState {
  final int overallRating;
  final int communication;
  final int easeOfUse;
  final int reliability;
  final int overallSatisfaction;
  final String reviewText;

  RatingUpdated({
    required this.overallRating,
    required this.communication,
    required this.easeOfUse,
    required this.reliability,
    required this.overallSatisfaction,
    required this.reviewText,
  });
}

class RatingLoading extends RatingState {}

class RatingSuccess extends RatingState {}

class RatingFailure extends RatingState {
  final String message;
  RatingFailure(this.message);
}