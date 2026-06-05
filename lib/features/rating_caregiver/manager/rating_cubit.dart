import 'package:ehtemam_final_project/features/rating_caregiver/manager/rating_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit() : super(RatingUpdated(
    overallRating: 0,
    communication: 0,
    easeOfUse: 0,
    reliability: 0,
    overallSatisfaction: 0,
    reviewText: '',
  ));

  void updateOverallRating(int value) {
    if (state is RatingUpdated) {
      final s = state as RatingUpdated;
      emit(RatingUpdated(
        overallRating: value,
        communication: s.communication,
        easeOfUse: s.easeOfUse,
        reliability: s.reliability,
        overallSatisfaction: s.overallSatisfaction,
        reviewText: s.reviewText,
      ));
    }
  }

  void updateCommunication(int value) {
    if (state is RatingUpdated) {
      final s = state as RatingUpdated;
      emit(RatingUpdated(
        overallRating: s.overallRating,
        communication: value,
        easeOfUse: s.easeOfUse,
        reliability: s.reliability,
        overallSatisfaction: s.overallSatisfaction,
        reviewText: s.reviewText,
      ));
    }
  }

  void updateEaseOfUse(int value) {
    if (state is RatingUpdated) {
      final s = state as RatingUpdated;
      emit(RatingUpdated(
        overallRating: s.overallRating,
        communication: s.communication,
        easeOfUse: value,
        reliability: s.reliability,
        overallSatisfaction: s.overallSatisfaction,
        reviewText: s.reviewText,
      ));
    }
  }

  void updateReliability(int value) {
    if (state is RatingUpdated) {
      final s = state as RatingUpdated;
      emit(RatingUpdated(
        overallRating: s.overallRating,
        communication: s.communication,
        easeOfUse: s.easeOfUse,
        reliability: value,
        overallSatisfaction: s.overallSatisfaction,
        reviewText: s.reviewText,
      ));
    }
  }

  void updateOverallSatisfaction(int value) {
    if (state is RatingUpdated) {
      final s = state as RatingUpdated;
      emit(RatingUpdated(
        overallRating: s.overallRating,
        communication: s.communication,
        easeOfUse: s.easeOfUse,
        reliability: s.reliability,
        overallSatisfaction: value,
        reviewText: s.reviewText,
      ));
    }
  }

  void updateReview(String text) {
    if (state is RatingUpdated) {
      final s = state as RatingUpdated;
      emit(RatingUpdated(
        overallRating: s.overallRating,
        communication: s.communication,
        easeOfUse: s.easeOfUse,
        reliability: s.reliability,
        overallSatisfaction: s.overallSatisfaction,
        reviewText: text,
      ));
    }
  }

  void submitRating() {
    if (state is! RatingUpdated) return;
    final current = state as RatingUpdated;
    emit(RatingLoading());
    try {
      emit(RatingSuccess());
    } catch (e) {
      emit(RatingFailure(e.toString()));
      emit(current);
    }
  }
}