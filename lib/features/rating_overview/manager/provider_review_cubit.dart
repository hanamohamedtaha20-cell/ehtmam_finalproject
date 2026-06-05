import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/provider_review_repo.dart';
import 'provider_review_state.dart';

class ProviderReviewCubit extends Cubit<ProviderReviewState> {
  final ProviderReviewRepo _repo;

  ProviderReviewCubit(this._repo) : super(ProviderReviewInitial());

  Future<void> loadReviews() async {
    emit(ProviderReviewLoading());
    try {
      final summary = await _repo.getSummary();
      final reviews = await _repo.getReviews();
      emit(ProviderReviewLoaded(summary: summary, reviews: reviews));
    } catch (e) {
      emit(ProviderReviewError(e.toString()));
    }
  }

  Future<void> filterByStar(int? star) async {
    final current = state;
    if (current is! ProviderReviewLoaded) return;

    final newFilter = current.activeStarFilter == star ? null : star;
    emit(current.copyWith(activeStarFilter: newFilter, clearFilter: newFilter == null));

    try {
      final reviews = await _repo.getReviews(starFilter: newFilter);
      if (state is ProviderReviewLoaded) {
        emit((state as ProviderReviewLoaded).copyWith(reviews: reviews));
      }
    } catch (e) {
      emit(ProviderReviewError(e.toString()));
    }
  }

  Future<void> markHelpful(String reviewId) async {
    final current = state;
    if (current is! ProviderReviewLoaded) return;
    if (current.helpfulIds.contains(reviewId)) return;

    final updated = {...current.helpfulIds, reviewId};
    emit(current.copyWith(helpfulIds: updated));

    try {
      await _repo.markHelpful(reviewId);
    } catch (_) {
      final rolledBack = Set<String>.from(updated)..remove(reviewId);
      if (state is ProviderReviewLoaded) {
        emit((state as ProviderReviewLoaded).copyWith(helpfulIds: rolledBack));
      }
    }
  }
}