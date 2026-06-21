import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/model/provider_data.dart';
import 'package:easy_localization/easy_localization.dart';


class SpecializationBox extends StatelessWidget {
  const SpecializationBox({
    super.key,
    required this.provider,
  });

  final ProviderModel provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(13.r),
      decoration: BoxDecoration(
        color: Color(0xFFF1F3F8),
        borderRadius: BorderRadius.circular(14.r),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text('specialization'.tr(),
            style: TextStyle(
              color: Color(0xFF432DD7),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            provider.specialization,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}