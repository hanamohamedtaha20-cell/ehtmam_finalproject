import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/provider_data.dart';

class ProviderInfo extends StatelessWidget {
  const ProviderInfo({super.key,required this.provider});
  final ProviderModel provider;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔹 Avatar
        Container(
          width: 55.w,
          height: 55.h,
          decoration: BoxDecoration(
            color: Color(0xFFEDEBFA),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: Text("👩‍🦱", style: TextStyle(fontSize: 28.sp)),
          ),
        ),

        SizedBox(width: 12.w),

        /// 🔹 Info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Name
            Text(
             provider.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),

            SizedBox(height: 2.h),

            if (provider.service.isNotEmpty || provider.location.isNotEmpty)
              Text(
                provider.service.isNotEmpty
                    ? provider.service
                    : provider.location,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.sp,
                ),
              ),

            if (provider.location.isNotEmpty && provider.service.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Text(
                provider.location,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.sp,
                ),
              ),
            ],

            if (provider.isVerified || provider.isCertified) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  if (provider.isVerified)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Color(0xFFE6F0FF),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.verified_outlined,
                              size: 14.r, color: Colors.blue),
                          SizedBox(width: 4.w),
                          Text(
                            "Verified",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (provider.isVerified && provider.isCertified)
                    SizedBox(width: 6.w),
                  if (provider.isCertified)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Color(0xFFE6F7ED),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.workspace_premium_outlined,
                              size: 14.r, color: Colors.green),
                          SizedBox(width: 4.w),
                          Text(
                            "Certified",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}