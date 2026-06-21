import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ProposedPriceCard extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController notesController;

  const ProposedPriceCard({
    super.key,
    required this.controller,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 22.h,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18.r),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6.r,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          /// TITLE
          Row(
            children: [
              Icon(
                Icons.attach_money,
                size: 18.r,
                color: Colors.grey.shade700,
              ),

              SizedBox(width: 8.w),

              Text(
                "YOUR PROPOSED PRICE",

                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),

          SizedBox(height: 15.h),

          /// PRICE FIELD
          Container(
            height: 55.h,

            decoration: BoxDecoration(
              color: Color(0xFFF7F9FC),

              borderRadius:
              BorderRadius.circular(18.r),

              border: Border.all(
                color: Color(0xFFDCE3EB),
              ),
            ),

            child: TextField(
              controller: controller,

              keyboardType:
              TextInputType.number,

              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF445164),
              ),

              decoration: InputDecoration(
                border: InputBorder.none,

                contentPadding:
                 EdgeInsets.symmetric(
                  vertical: 20.h,
                ),

                prefixIcon: Padding(
                  padding: EdgeInsets.only(
                    left: 14.w,
                    right: 6.w,
                  ),

                  child: Icon(
                    Icons.attach_money,
                    color: Color(0xFF00A86B),
                    size: 25.r,
                  ),
                ),

                hintText:
                'enter_price'.tr(),

                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

           SizedBox(height: 12.h),

          /// DESCRIPTION
          Text(
            "Enter the price you'd charge for this service",

            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade500,
              height: 1.4.h,
            ),
          ),

           SizedBox(height: 14.h),

          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),

           SizedBox(height: 14.h),

          /// NOTES TITLE
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 17.r,
                color: Colors.grey.shade700,
              ),

               SizedBox(width: 6.w),

              Text('notes_optional'.tr(),

                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),

           SizedBox(height: 14.h),

          /// NOTES FIELD
          Container(
            height: 120.h,

            decoration: BoxDecoration(
              color:  Color(0xFFF7F9FC),

              borderRadius:
              BorderRadius.circular(18.r),

              border: Border.all(
                color:  Color(0xFFDCE3EB),
              ),
            ),

            child: TextField(
              controller: notesController,

              maxLines: null,
              expands: true,

              textAlignVertical:
              TextAlignVertical.top,

              decoration: InputDecoration(
                border: InputBorder.none,

                contentPadding:
                 EdgeInsets.all(16.r),

                hintText:
                'add_notes'.tr(),

                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}