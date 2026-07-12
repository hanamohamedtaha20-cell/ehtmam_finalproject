import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_service.dart';
import '../model/active_bundle_model.dart';
import '../model/bundels_model.dart';

class BundleRepo {
  final ApiService apiService;

  BundleRepo(this.apiService);

  Future<List<BundleModel>> getBundles() async {
    // Load local purchased state as a fallback for when the API is slow or
    // temporarily unavailable. Keyed by userId so state is user-specific.
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    final localPurchasedId =
        prefs.getString('purchased_bundle_id_$userId') ?? '';

    // 1. Fetch all available bundles + user's active bundle in parallel.
    final results = await Future.wait([
      apiService.getAllBundles(),
      apiService.getMyActiveBundle().catchError((_) => <String, dynamic>{}),
    ]);

    final allBundlesResponse = results[0];
    final activeBundleResponse = results[1];

    debugPrint('ALL_BUNDLES_RESPONSE: $allBundlesResponse');
    debugPrint('USER_PURCHASED_BUNDLES_RESPONSE: $activeBundleResponse');

    // 2. Parse the active bundle (null if none / endpoint errored).
    ActiveBundleModel? active;
    try {
      final raw = activeBundleResponse;
      final activeData = raw['data'] ??
          raw['clientBundle'] ??
          raw['clientbundle'] ??
          (raw['_id'] != null ? raw : null);
      if (activeData is Map<String, dynamic> && activeData.isNotEmpty) {
        active = ActiveBundleModel.fromJson(activeData);
        debugPrint(
            '[BundleRepo] parsed active: id=${active.id}  bundleId=${active.bundleId}  name=${active.bundleName}  isActive=${active.isActive}');
      } else {
        debugPrint('[BundleRepo] no active bundle found in response');
      }
    } catch (e) {
      debugPrint('[BundleRepo] error parsing active bundle: $e');
    }

    // 3. Parse all bundles and mark the purchased one.
    final rawList = (allBundlesResponse['data'] ??
        allBundlesResponse['bundles'] ??
        (allBundlesResponse is List ? allBundlesResponse : [])) as List;

    final bundles = rawList.map((item) {
      final json = item as Map<String, dynamic>;
      final base = BundleModel.fromJson(json);

      // Primary check: match against the API-confirmed active bundle.
      final apiConfirmed = active != null &&
          active.isActive &&
          (active.bundleId == base.id ||
              active.bundleName == base.bundleName);

      // Fallback check: match against locally persisted bundle ID.
      // Used when getMyActiveBundle() fails or returns empty.
      final localConfirmed =
          localPurchasedId.isNotEmpty && localPurchasedId == base.id;

      final isPurchased = apiConfirmed || localConfirmed;

      debugPrint(
          '[BundleRepo] bundle ${base.id} "${base.bundleName}" → isPurchased=$isPurchased  apiConfirmed=$apiConfirmed  localConfirmed=$localConfirmed');

      // When the API confirms the purchased bundle, keep SharedPreferences
      // in sync so the fallback stays accurate.
      if (apiConfirmed && userId.isNotEmpty && base.id.isNotEmpty) {
        prefs.setString('purchased_bundle_id_$userId', base.id);
      }

      return base.copyWith(
        isPurchased: isPurchased,
        // Session counts come from the API only (local fallback has no count data).
        totalSessions:
            apiConfirmed ? active.totalSessions : base.totalSessions,
        remainingSessions:
            apiConfirmed ? active.remainingSessions : base.remainingSessions,
      );
    }).toList();

    // 4. Sort: purchased/active bundle first, rest in original order.
    bundles.sort((a, b) {
      if (a.isPurchased && !b.isPurchased) return -1;
      if (!a.isPurchased && b.isPurchased) return 1;
      return 0;
    });

    return bundles;
  }
}
