import 'package:ehtemam_final_project/features/rating_caregiver/data/repo/rating_repo.dart';
import 'package:ehtemam_final_project/features/rating_caregiver/manager/rating_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatingGiverCubit extends Cubit<RatingState> {
  final String bookingId;
  final RatingRepo _repo;

  RatingGiverCubit({required this.bookingId, RatingRepo? repo})
      : _repo = repo ?? RatingRepoImpl(),
        super(RatingUpdated(
          overallRating: 3,
          communication: 3,
          easeOfUse: 3,
          reliability: 3,
          overallSatisfaction: 3,
          reviewText: '',
        ));

  void updateOverallRating(int value) => _update((s) => RatingUpdated(
        overallRating: value,
        communication: s.communication,
        easeOfUse: s.easeOfUse,
        reliability: s.reliability,
        overallSatisfaction: s.overallSatisfaction,
        reviewText: s.reviewText,
      ));

  void updateCommunication(int value) => _update((s) => RatingUpdated(
        overallRating: s.overallRating,
        communication: value,
        easeOfUse: s.easeOfUse,
        reliability: s.reliability,
        overallSatisfaction: s.overallSatisfaction,
        reviewText: s.reviewText,
      ));

  void updateEaseOfUse(int value) => _update((s) => RatingUpdated(
        overallRating: s.overallRating,
        communication: s.communication,
        easeOfUse: value,
        reliability: s.reliability,
        overallSatisfaction: s.overallSatisfaction,
        reviewText: s.reviewText,
      ));

  void updateReliability(int value) => _update((s) => RatingUpdated(
        overallRating: s.overallRating,
        communication: s.communication,
        easeOfUse: s.easeOfUse,
        reliability: value,
        overallSatisfaction: s.overallSatisfaction,
        reviewText: s.reviewText,
      ));

  void updateOverallSatisfaction(int value) => _update((s) => RatingUpdated(
        overallRating: s.overallRating,
        communication: s.communication,
        easeOfUse: s.easeOfUse,
        reliability: s.reliability,
        overallSatisfaction: value,
        reviewText: s.reviewText,
      ));

  void _update(RatingUpdated Function(RatingUpdated s) fn) {
    if (state is RatingUpdated) emit(fn(state as RatingUpdated));
  }

  Future<void> submitRating({required String review}) async {
    if (state is! RatingUpdated) return;
    final current = state as RatingUpdated;
    if (current.overallRating == 0) return;

    emit(RatingLoading());
    try {
      await _repo.submitRating(
        bookingId: bookingId,
        overallRating: current.overallRating,
        professionalismRating: current.overallSatisfaction,
        serviceQualityRating: current.easeOfUse,
        punctualityRating: current.reliability,
        communicationRating: current.communication,
        reviewComment: review,
      );
      emit(RatingSuccess());
    } catch (e) {
      emit(RatingFailure(e.toString()));
      emit(current);
    }
  }
}
