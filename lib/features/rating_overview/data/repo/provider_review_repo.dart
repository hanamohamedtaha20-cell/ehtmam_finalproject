import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/provider_review_model.dart';

abstract class ProviderReviewRepo {
  Future<ProviderReviewSummaryModel> getSummary();
  Future<List<ProviderReviewModel>> getReviews({int? starFilter});
  Future<void> markHelpful(String reviewId);
}

class ProviderReviewRepoImpl implements ProviderReviewRepo {
  final ApiService _api = ApiService();

  List<ProviderReviewModel>? _cachedReviews;
  ProviderReviewSummaryModel? _cachedSummary;

  /// Clears the cache so the next load fetches fresh data from the API.
  void invalidate() {
    _cachedReviews = null;
    _cachedSummary = null;
  }

  /// Fetches from /review/caregiver/{userId} and caches the result.
  /// Subsequent calls return the cache without hitting the network.
  Future<void> _fetchAll() async {
    if (_cachedReviews != null && _cachedSummary != null) return;

    final prefs = await SharedPreferences.getInstance();
    final caregiverId = prefs.getString('userId') ?? '';

    final response = await _api.getCaregiverReviews(caregiverId);

    // Response: { "status": "success", "data": { "reviews": [...],
    //   "averageRating": 5, "totalReviewsCount": 1,
    //   "ratingBreakdown": { "1": 0, ... } } }
    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      _cachedSummary = ProviderReviewSummaryModel.fromApiData({});
      _cachedReviews = [];
      return;
    }

    _cachedSummary = ProviderReviewSummaryModel.fromApiData(data);

    final rawList = data['reviews'];
    _cachedReviews = rawList is List
        ? rawList
            .whereType<Map<String, dynamic>>()
            .map(ProviderReviewModel.fromJson)
            .toList()
        : [];
  }

  @override
  Future<ProviderReviewSummaryModel> getSummary() async {
    await _fetchAll();
    return _cachedSummary!;
  }

  @override
  Future<List<ProviderReviewModel>> getReviews({int? starFilter}) async {
    await _fetchAll();
    final all = _cachedReviews!;
    if (starFilter == null) return all;
    return all.where((r) => r.rating.round() == starFilter).toList();
  }

  @override
  Future<void> markHelpful(String reviewId) async {}
}
