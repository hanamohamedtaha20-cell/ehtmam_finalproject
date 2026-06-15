import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/model/bundels_model.dart';
import '../../screens/bundle_payment_screen.dart';
import 'bundels_features.dart';
import 'bundels_header.dart';

class BundleCard extends StatelessWidget {
  final BundleModel bundle;

  const BundleCard({
    super.key,
    required this.bundle,
  });

  List<String> get _features {
    if (bundle.features.isNotEmpty) return bundle.features;

    final items = <String>[
      'Price: ${bundle.displayPrice.toStringAsFixed(0)} SAR',
    ];

    if (bundle.discountPercent > 0) {
      items.add('Discount: ${bundle.discountPercent}%');
    }

    return items;
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
        children: [
          BundleHeader(bundle: bundle),
          SizedBox(height: 12.h),
          BundleFeatures(features: _features),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BundlePaymentScreen(
                      bundleId: bundle.id,
                      bundleName: bundle.bundleName,
                      bundlePrice: bundle.displayPrice,
                    ),
                  ),
                );
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
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
