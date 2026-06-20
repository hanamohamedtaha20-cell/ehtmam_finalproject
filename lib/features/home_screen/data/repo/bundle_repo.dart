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
      final activeData = activeBundleResponse['data'];
      if (activeData is Map<String, dynamic> && activeData.isNotEmpty) {
        active = ActiveBundleModel.fromJson(activeData);
      }
    } catch (_) {}

    // 3. Parse all bundles and mark the purchased one.
    final List rawList = allBundlesResponse['data'] ?? [];
    final bundles = rawList.map((item) {
      final json = item as Map<String, dynamic>;
      final base = BundleModel.fromJson(json);

      final isPurchased = active != null &&
          active.isActive &&
          (active.bundleId == base.id ||
              (active.bundleId.isEmpty &&
                  active.bundleName == base.bundleName));

      final model = base.copyWith(
        isPurchased: isPurchased,
        totalSessions: isPurchased
            ? active.totalSessions
            : base.totalSessions,
        remainingSessions: isPurchased
            ? active.remainingSessions
            : base.remainingSessions,
      );

      debugPrint('BUNDLE_ID: ${model.id}');
      debugPrint('IS_PURCHASED: ${model.isPurchased}');
      debugPrint('TOTAL_SESSIONS: ${model.totalSessions}');
      debugPrint('REMAINING_SESSIONS: ${model.remainingSessions}');
      debugPrint('PRICE_EGP: ${model.price}');

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
