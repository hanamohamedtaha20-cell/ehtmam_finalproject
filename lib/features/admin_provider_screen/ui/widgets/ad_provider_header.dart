import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class AdProviderHeader extends StatelessWidget {
  final Function(String)? onSearch;

  const AdProviderHeader({
    super.key,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('providers'.tr(),
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xff1F2937),
            ),
          ),

          SizedBox(height: 20.h),

          SizedBox(
            height: 56.h,
            child: TextField(
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'search_providers'.tr(),
                hintStyle: TextStyle(
                  color: Color(0xff9CA3AF),
                  fontSize: 15.sp,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 28.r,
                  color: Color(0xff6B7280),
                ),
                filled: true,
                fillColor: const Color(0xffF3F4F6),
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          Divider(
            height: 1.h,
            thickness: 1,
            color: Color(0xffE5E7EB),
          ),
        ],
      ),
    );
  }
}