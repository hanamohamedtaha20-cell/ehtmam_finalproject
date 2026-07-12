import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/model/bundels_model.dart';
import '../../screens/bundle_payment_screen.dart';
import 'bundels_features.dart';
import 'bundels_header.dart';
import 'package:easy_localization/easy_localization.dart';

class BundleCard extends StatefulWidget {
  final VoidCallback? onPurchased;
  final BundleModel bundle;

  const BundleCard({
    super.key,
    required this.bundle,
    this.onPurchased,
  });

  @override
  State<BundleCard> createState() => _BundleCardState();
}

class _BundleCardState extends State<BundleCard> {
  bool isPurchased = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    isPurchased = widget.bundle.isPurchased;
  }

  // Sync local state when the parent rebuilds with an updated bundle model
  // (e.g. after BundleCubit.getBundles() re-fetches and marks isPurchased=true).
  @override
  void didUpdateWidget(BundleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bundle.isPurchased != oldWidget.bundle.isPurchased) {
      setState(() {
        isPurchased = widget.bundle.isPurchased;
      });
    }
  }

  Future<void> _savePurchasedLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    if (userId.isNotEmpty && widget.bundle.id.isNotEmpty) {
      await prefs.setString('purchased_bundle_id_$userId', widget.bundle.id);
    }
  }

  Future<void> _onPurchaseButtonTapped() async {
    if (_isLoading || isPurchased) return;

    setState(() => _isLoading = true);

    final purchased = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BundlePaymentScreen(
          bundleId: widget.bundle.id,
          bundleName: widget.bundle.bundleName,
          bundlePrice: widget.bundle.displayPrice,
        ),
      ),
    );

    if (!mounted) return;

    if (purchased == true) {
      // Persist locally so the button survives a screen re-visit
      // even if the API is temporarily slow or unavailable.
      await _savePurchasedLocally();
      setState(() {
        isPurchased = true;
        _isLoading = false;
      });
      widget.onPurchased?.call();
    } else {
      // Payment was cancelled or failed — do not mark as purchased.
      setState(() => _isLoading = false);
    }
  }

  List<String> get _features {
    if (widget.bundle.features.isNotEmpty) return widget.bundle.features;

    final items = <String>[
      'Price: ${widget.bundle.displayPrice.toStringAsFixed(0)} EGP',
    ];

    if (widget.bundle.discountPercent > 0) {
      items.add('Discount: ${widget.bundle.discountPercent}%');
    }

    return items;
  }

  String get _sessionsText {
    if (widget.bundle.isPurchased && widget.bundle.totalSessions > 0) {
      return 'Remaining Sessions: ${widget.bundle.remainingSessions} / ${widget.bundle.totalSessions}';
    }
    if (widget.bundle.totalSessions > 0) {
      return '${widget.bundle.totalSessions} Sessions';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BundleHeader(bundle: widget.bundle),
          SizedBox(height: 8.h),

          // Sessions row
          if (_sessionsText.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 14.r, color: Colors.green),
                  SizedBox(width: 6.w),
                  Text(
                    _sessionsText,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: widget.bundle.isPurchased
                          ? Colors.green.shade700
                          : Colors.grey.shade700,
                      fontWeight: widget.bundle.isPurchased
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

          BundleFeatures(features: _features),
          SizedBox(height: 16.h),

          SizedBox(
            width: double.infinity,
            child: _isLoading
                ? ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      disabledBackgroundColor: Colors.green.withValues(alpha: 0.7),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: SizedBox(
                      height: 20.r,
                      width: 20.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : isPurchased
                    ? OutlinedButton(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.blue, width: 1.5),
                          foregroundColor: AppColors.blue,
                          disabledForegroundColor: AppColors.blue,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'purchased'.tr(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blue,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _onPurchaseButtonTapped,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'purchase_bundle'.tr(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
