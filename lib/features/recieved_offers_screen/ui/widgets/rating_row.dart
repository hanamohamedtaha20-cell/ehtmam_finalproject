import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/provider_data.dart';
import 'package:easy_localization/easy_localization.dart';

class RatingRow extends StatelessWidget {
  const RatingRow({super.key,required this.provider});
  final ProviderModel provider;
  bool get _hasStats =>
      provider.rating > 0 ||
      provider.reviewsCount > 0 ||
      provider.experience.isNotEmpty ||
      provider.completed > 0;

  @override
  Widget build(BuildContext context) {
    if (!_hasStats) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          /// 🔹 Rating
          Column(
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 18.r),
                  SizedBox(width: 4.w),
                  Text(
                      "${provider.rating}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                "(${provider.reviewsCount})",
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
            ],
          ),

          /// 🔹 Divider
          Container(
            height: 30.h,
            width: 1.w,
            color: Colors.grey.shade300,
          ),

          if (provider.experience.isNotEmpty) ...[
            Container(
              height: 30.h,
              width: 1.w,
              color: Colors.grey.shade300,
            ),
            Column(
              children: [
                Text(
                  provider.experience,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text('years_experience'.tr(),
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
              ],
            ),
          ],

          if (provider.completed > 0) ...[
            Container(
              height: 30.h,
              width: 1.w,
              color: Colors.grey.shade300,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.people, size: 16.r, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      "${provider.completed}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text('completed_services'.tr(),
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
