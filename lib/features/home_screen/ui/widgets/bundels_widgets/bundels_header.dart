import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/model/bundels_model.dart';

class BundleHeader extends StatelessWidget {
  final BundleModel bundle;

  const BundleHeader({
    super.key,
    required this.bundle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          child: Icon(Icons.local_offer_outlined),
        ),
        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bundle.bundleName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (bundle.discountPercent > 0)
                Text(
                  'Discount ${bundle.discountPercent}%',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                  ),
                ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              bundle.displayPrice.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'EGP',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}