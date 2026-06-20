import 'package:ehtemam_final_project/core/network/api_service.dart';
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

  void invalidate() {
    _cachedReviews = null;
    _cachedSummary = null;
  }

  /// Fetches from GET /review/my-reviews (token-based, works for both Client and Caregiver).
  Future<void> _fetchAll() async {
    if (_cachedReviews != null && _cachedSummary != null) return;

    final response = await _api.getMyReviews();

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      _cachedSummary = ProviderReviewSummaryModel.fromApiData({});
      _cachedReviews = [];
      return;
    }

    _cachedSummary = ProviderReviewSummaryModel.fromApiData(data);

    final rawList = data['reviews'];
    if (rawList is List) {
      final items = rawList.whereType<Map<String, dynamic>>().toList();
      items.sort((a, b) {
        final aStr = a['createdAt']?.toString() ?? a['_id']?.toString() ?? '';
        final bStr = b['createdAt']?.toString() ?? b['_id']?.toString() ?? '';
        return bStr.compareTo(aStr);
      });
      _cachedReviews = items.map(ProviderReviewModel.fromJson).toList();
    } else {
      _cachedReviews = [];
    }
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
