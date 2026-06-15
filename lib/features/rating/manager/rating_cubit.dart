import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/rating_model.dart';
import '../data/repo/rating_repo.dart';
import 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final RatingRepo repo;

  RatingCubit(this.repo) : super(RatingInitial());

  int overall         = 0;
  int professionalism = 0;
  int serviceQuality  = 0;
  int punctuality     = 0;
  int communication   = 0;

  void updateRating(String type, int value) {
    switch (type) {
      case "overall":        overall        = value; break;
      case "professionalism": professionalism = value; break;
      case "serviceQuality": serviceQuality  = value; break;
      case "punctuality":    punctuality     = value; break;
      case "communication":  communication   = value; break;
    }
    emit(RatingInitial());
  }

  Future<void> submit({
    required String review,
    required String bookingId,
  }) async {
    if (isClosed) return;
    emit(RatingLoading());
    try {
      await repo.submitRating(
        model: RatingModel(
          overall:        overall,
          professionalism: professionalism,
          serviceQuality:  serviceQuality,
          punctuality:     punctuality,
          communication:   communication,
          review:          review,
        ),
        bookingId: bookingId,
      );
      if (!isClosed) {
        emit(RatingSuccess());
      }
    } catch (e) {
      if (!isClosed) {
        emit(RatingError(e.toString()));
      }
    }
  }
}
