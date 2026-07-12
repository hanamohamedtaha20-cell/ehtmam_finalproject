import 'package:ehtemam_final_project/core/resources/custom_snack_bar.dart';
import 'package:ehtemam_final_project/core/utils/api_error_message.dart';
import 'package:ehtemam_final_project/features/home_screen/data/model/active_bundle_model.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/screens/home_screen.dart';
import 'package:ehtemam_final_project/features/payment/data/repo/payment_repo.dart';
import 'package:ehtemam_final_project/features/payment/manager/payment_cubit.dart';
import 'package:ehtemam_final_project/features/payment/ui/screens/payment_screen.dart';
import 'package:ehtemam_final_project/features/recieved_offers_screen/data/repo/Provider_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── helpers ──────────────────────────────────────────────────────────────────

int _toInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}


// ─────────────────────────────────────────────────────────────────────────────
// Public entry-point — called from OfferDetailsScreen
// ─────────────────────────────────────────────────────────────────────────────

Future<void> acceptOffer({
  required BuildContext context,
  required String offerId,
  required String requestId,
  double? offerPrice,
  bool popOnSuccess = false,
}) async {
  if (offerId.trim().isEmpty) {
    CustomSnackBar.show(context, message: 'Offer id is missing');
    return;
  }

  final prefs = await SharedPreferences.getInstance();
  final repository = ProviderRepository();

  final userId = prefs.getString('userId') ?? '';
  debugPrint('ACCEPT_OFFER_START: offerId=$offerId, requestId=$requestId');
  debugPrint('USER_ID: $userId');
  debugPrint('OFFER_ID: $offerId');

  // ── Silent bundle check ──────────────────────────────────────────────────
  ActiveBundleModel? activeBundle;
  try {
    activeBundle = await repository.getActiveBundle();
  } catch (_) {
    activeBundle = null;
  }

  debugPrint('ACTIVE_BUNDLE_ID: ${activeBundle?.id ?? "none"}');
  debugPrint('REMAINING_SESSIONS_BEFORE: ${activeBundle?.remainingSessions ?? 0}');

  if (!context.mounted) return;

  // ── Route based on bundle availability ─────────────────────────────────
  if (activeBundle != null) {
    final useBundle = await _showBundleDialog(context, activeBundle, offerPrice);
    if (useBundle == null) return; // user dismissed

    if (useBundle) {
      await _acceptWithBundle(
        context: context,
        repository: repository,
        prefs: prefs,
        offerId: offerId,
        requestId: requestId,
        activeBundle: activeBundle,
        popOnSuccess: popOnSuccess,
        offerPrice: offerPrice,
      );
      return;
    }
    // useBundle == false → fall through to wallet
  }

  await _acceptWithWallet(
    context: context,
    repository: repository,
    prefs: prefs,
    offerId: offerId,
    requestId: requestId,
    offerPrice: offerPrice,
    popOnSuccess: popOnSuccess,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Bundle confirmation dialog
// Returns true → use bundle | false → use wallet | null → dismissed
// ─────────────────────────────────────────────────────────────────────────────

Future<bool?> _showBundleDialog(
  BuildContext context,
  ActiveBundleModel bundle,
  double? offerPrice,
) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: const [
            BoxShadow(color: Color(0x1F000000), blurRadius: 20, offset: Offset(0, 8)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: const BoxDecoration(
                color: Color(0xFFE3F2FD),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.inventory_2_outlined,
                  color: const Color(0xFF3A8BD7), size: 34.r),
            ),
            SizedBox(height: 16.h),
            Text(
              'Active Bundle Detected',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Arimo',
                fontWeight: FontWeight.bold,
                fontSize: 17.sp,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'This booking will use 1 session from your active bundle. '
              'No wallet balance will be deducted.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 13.sp,
                color: Colors.grey.shade600,
                height: 1.45,
              ),
            ),
            SizedBox(height: 16.h),
            _BundleInfoCard(
              rows: [
                _InfoRow(Icons.inventory_2_outlined, 'Bundle', bundle.bundleName),
                _InfoRow(Icons.confirmation_num_outlined, 'Sessions remaining',
                    '${bundle.remainingSessions}'),
                if (offerPrice != null && offerPrice > 0)
                  _InfoRow(Icons.savings_outlined, 'Wallet saved',
                      '${offerPrice.toStringAsFixed(0)} EGP',
                      valueColor: const Color(0xFF2E7D32)),
              ],
            ),
            SizedBox(height: 22.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A8BD7),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r)),
                ),
                child: Text(
                  'Use Bundle Session',
                  style: TextStyle(
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade600,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r)),
                ),
                child: Text(
                  'Pay with Wallet Instead',
                  style: TextStyle(fontFamily: 'Arimo', fontSize: 13.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Accept with bundle session — auto-deduct, no manual payment step
// ─────────────────────────────────────────────────────────────────────────────

Future<void> _acceptWithBundle({
  required BuildContext context,
  required ProviderRepository repository,
  required SharedPreferences prefs,
  required String offerId,
  required String requestId,
  required ActiveBundleModel activeBundle,
  required bool popOnSuccess,
  double? offerPrice,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final response = await repository.acceptOfferWithBundle(offerId);

    final data = response['data'];
    final rawSessions = data is Map ? data['remainingSessions'] : null;
    final remainingSessions = rawSessions != null
        ? (_toInt(rawSessions) > 0
            ? _toInt(rawSessions)
            : activeBundle.remainingSessions - 1)
        : (activeBundle.remainingSessions - 1);

    debugPrint('PAYMENT_METHOD_USED: bundle');
    debugPrint('REMAINING_BUNDLE_SESSIONS: $remainingSessions');
    debugPrint('BACKEND_RESPONSE: $response');

    final bookingId = await repository.findBookingForAcceptedOffer(
        offerId, requestId: requestId);
    if (bookingId.isNotEmpty) {
      await prefs.setString('bookingId', bookingId);
    } else {
      await prefs.remove('bookingId');
    }
    await prefs.setString('acceptedOfferId', offerId.trim());

    if (!context.mounted) return;
    Navigator.pop(context); // close loading

    if (popOnSuccess && Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    if (!context.mounted) return;
    CustomSnackBar.show(
      context,
      message: 'Booking confirmed! 1 bundle session used. '
          '$remainingSessions session(s) remaining.',
    );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen(initialIndex: 2)),
      (_) => false,
    );
  } catch (e) {
    if (context.mounted) {
      Navigator.pop(context);
      CustomSnackBar.show(context, message: apiErrorMessage(e));
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Accept with wallet — navigate to PaymentScreen; user manually confirms payment
// ─────────────────────────────────────────────────────────────────────────────

Future<void> _acceptWithWallet({
  required BuildContext context,
  required ProviderRepository repository,
  required SharedPreferences prefs,
  required String offerId,
  required String requestId,
  required double? offerPrice,
  required bool popOnSuccess,
}) async {
  if (popOnSuccess && context.mounted && Navigator.canPop(context)) {
    Navigator.pop(context);
  }

  if (!context.mounted) return;

  // Navigate to PaymentScreen; the user explicitly presses Pay there,
  // which calls processPayment(offerId) → deducts wallet + creates booking.
  final paid = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => PaymentCubit(PaymentRepo())
          ..loadData(offerPrice: offerPrice),
        child: PaymentScreen(
          offerId: offerId,
        ),
      ),
    ),
  );

  if (!context.mounted) return;

  if (paid == true) {
    // Save identifiers for downstream screens.
    await prefs.setString('acceptedOfferId', offerId.trim());
    final bookingId = await repository.findBookingForAcceptedOffer(
        offerId, requestId: requestId);
    if (bookingId.isNotEmpty) {
      await prefs.setString('bookingId', bookingId);
    } else {
      await prefs.remove('bookingId');
    }

    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen(initialIndex: 2)),
      (_) => false,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared UI widgets
// ─────────────────────────────────────────────────────────────────────────────

class _InfoRow {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(this.icon, this.label, this.value, {this.valueColor});
}

class _BundleInfoCard extends StatelessWidget {
  final List<_InfoRow> rows;

  const _BundleInfoCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3A8BD7).withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            if (i > 0) SizedBox(height: 6.h),
            _RowWidget(row: rows[i]),
          ],
        ],
      ),
    );
  }
}

class _RowWidget extends StatelessWidget {
  final _InfoRow row;

  const _RowWidget({required this.row});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(row.icon, color: const Color(0xFF3A8BD7), size: 14.r),
        SizedBox(width: 6.w),
        Text(
          '${row.label}: ',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 12.sp,
            color: Colors.grey.shade600,
          ),
        ),
        Expanded(
          child: Text(
            row.value,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              color: row.valueColor ?? Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
