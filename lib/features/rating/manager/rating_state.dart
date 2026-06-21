abstract class RatingState {}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingSuccess extends RatingState {}

class RatingAlreadyReviewed extends RatingState {}

class RatingError extends RatingState {
  final String message;
  RatingError(this.message);
}