import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/model/bundels_model.dart';
import '../../screens/bundle_payment_screen.dart';
import 'bundels_features.dart';
import 'bundels_header.dart';

class BundleCard extends StatelessWidget {
  final VoidCallback? onPurchased;
  final BundleModel bundle;

  const BundleCard({
    super.key,
    required this.bundle,
    this.onPurchased,
  });

  List<String> get _features {
    if (bundle.features.isNotEmpty) return bundle.features;

    final items = <String>[
      'Price: ${bundle.displayPrice.toStringAsFixed(0)} EGP',
    ];

    if (bundle.discountPercent > 0) {
      items.add('Discount: ${bundle.discountPercent}%');
    }

    return items;
  }

  String get _sessionsText {
    if (bundle.isPurchased && bundle.totalSessions > 0) {
      return 'Remaining Sessions: ${bundle.remainingSessions} / ${bundle.totalSessions}';
    }
    if (bundle.totalSessions > 0) {
      return '${bundle.totalSessions} Sessions';
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
          BundleHeader(bundle: bundle),
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
                      color: bundle.isPurchased
                          ? Colors.green.shade700
                          : Colors.grey.shade700,
                      fontWeight: bundle.isPurchased
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
            child: bundle.isPurchased
                ? OutlinedButton(
                    onPressed: null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.green, width: 1.5),
                      foregroundColor: Colors.green,
                      disabledForegroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Purchased',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      final purchased = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BundlePaymentScreen(
                            bundleId: bundle.id,
                            bundleName: bundle.bundleName,
                            bundlePrice: bundle.displayPrice,
                          ),
                        ),
                      );
                      if (purchased == true && onPurchased != null) {
                        onPurchased!();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Purchase Bundle',
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

