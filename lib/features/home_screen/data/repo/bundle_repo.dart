import 'package:flutter/foundation.dart';
import '../../../../core/network/api_service.dart';
import '../model/active_bundle_model.dart';
import '../model/bundels_model.dart';

class BundleRepo {
  final ApiService apiService;

  BundleRepo(this.apiService);

  Future<List<BundleModel>> getBundles() async {
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
      // Backend may use 'data', 'clientBundle', 'bundle', or the root directly.
      final raw = activeBundleResponse;
      final activeData = raw['data'] ??
          raw['clientBundle'] ??
          raw['clientbundle'] ??
          (raw['_id'] != null ? raw : null);
      if (activeData is Map<String, dynamic> && activeData.isNotEmpty) {
        active = ActiveBundleModel.fromJson(activeData);
        debugPrint('[BundleRepo] parsed active: id=${active.id}  bundleId=${active.bundleId}  name=${active.bundleName}  isActive=${active.isActive}');
      } else {
        debugPrint('[BundleRepo] no active bundle found in response');
      }
    } catch (e) {
      debugPrint('[BundleRepo] error parsing active bundle: $e');
    }

    // 3. Parse all bundles and mark the purchased one.
    // Backend may use 'data', 'bundles', or the root list.
    final rawList = (allBundlesResponse['data'] ??
        allBundlesResponse['bundles'] ??
        (allBundlesResponse is List ? allBundlesResponse : [])) as List;

    final bundles = rawList.map((item) {
      final json = item as Map<String, dynamic>;
      final base = BundleModel.fromJson(json);

      // Match by ID first; fall back to name comparison.
      final isPurchased = active != null &&
          active.isActive &&
          (active.bundleId == base.id ||
              active.bundleName == base.bundleName);

      debugPrint('[BundleRepo] bundle ${base.id} "${base.bundleName}" → isPurchased=$isPurchased  (active.bundleId=${active?.bundleId}  active.name=${active?.bundleName})');

      final model = base.copyWith(
        isPurchased: isPurchased,
        totalSessions: isPurchased
            ? active.totalSessions
            : base.totalSessions,
        remainingSessions: isPurchased
            ? active.remainingSessions
            : base.remainingSessions,
      );

      return model;
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
