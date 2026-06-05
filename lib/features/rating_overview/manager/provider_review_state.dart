import '../data/model/provider_review_model.dart';

abstract class ProviderReviewState {}

class ProviderReviewInitial extends ProviderReviewState {}

class ProviderReviewLoading extends ProviderReviewState {}

class ProviderReviewLoaded extends ProviderReviewState {
  final ProviderReviewSummaryModel summary;
  final List<ProviderReviewModel> reviews;
  final int? activeStarFilter;
  final Set<String> helpfulIds;

  ProviderReviewLoaded({
    required this.summary,
    required this.reviews,
    this.activeStarFilter,
    this.helpfulIds = const {},
  });

  ProviderReviewLoaded copyWith({
    ProviderReviewSummaryModel? summary,
    List<ProviderReviewModel>? reviews,
    int? activeStarFilter,
    bool clearFilter = false,
    Set<String>? helpfulIds,
  }) {
    return ProviderReviewLoaded(
      summary: summary ?? this.summary,
      reviews: reviews ?? this.reviews,
      activeStarFilter: clearFilter ? null : (activeStarFilter ?? this.activeStarFilter),
      helpfulIds: helpfulIds ?? this.helpfulIds,
    );
  }
}

class ProviderReviewError extends ProviderReviewState {
  final String message;
  ProviderReviewError(this.message);
}