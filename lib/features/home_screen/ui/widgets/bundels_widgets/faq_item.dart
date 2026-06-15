import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQItem extends StatelessWidget {
  final String title;
  final String answer;

  const FAQItem({
    super.key,
    required this.title,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          childrenPadding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Text(
              answer,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade700,
                height: 1.5.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}