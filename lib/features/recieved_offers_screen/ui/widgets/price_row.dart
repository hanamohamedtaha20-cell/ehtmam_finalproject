import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/provider_data.dart';
import 'package:easy_localization/easy_localization.dart';


class PriceRow extends StatelessWidget {
  const PriceRow({super.key,required this.provider});
  final ProviderModel provider;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        /// 🔹 السعر
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// label
            Text('proposed_price'.tr(),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.sp,
              ),
            ),

            SizedBox(height: 4.h),


            Row(
              children: [
                if (provider.oldPrice > 0) ...[
                  Text(
                    "${provider.oldPrice.toStringAsFixed(0)} EGP",
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(width: 6.w),
                ],
                Text(
                  "${provider.price.toStringAsFixed(0)} EGP",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            if (provider.hourlyRate > 0) ...[
              SizedBox(height: 4.h),
              Text(
                "${provider.hourlyRate.toStringAsFixed(0)} EGP / hr",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        ),

        if (provider.bestValue)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Color(0xFF16A34A),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8.r,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text('best_value'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
          ),

      ],
    );
  }
}