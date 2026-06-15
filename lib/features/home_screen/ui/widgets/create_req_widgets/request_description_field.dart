import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_card.dart';

class RequestDescriptionField
    extends StatelessWidget {

  const RequestDescriptionField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Icon(
                Icons.description_outlined,
                size: 18.r,
                color: Colors.blueGrey,
              ),

              SizedBox(width: 6.w),

              Text(
                "Description",

                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                " *",

                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          TextFormField(
            maxLines: 5,

            validator: (value) {

              if (value == null ||
                  value.trim().isEmpty) {

                return
                  "Description is required";
              }

              return null;
            },

            decoration: InputDecoration(
              hintText:
              "Describe what you need...",

              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14.sp,
              ),

              filled: true,

              fillColor:
              const Color(0xFFF5F7FA),

              contentPadding:
              EdgeInsets.all(16.r),

              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14.r),

                borderSide:
                BorderSide.none,
              ),

              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14.r),

                borderSide:
                BorderSide.none,
              ),

              focusedBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14.r),

                borderSide: BorderSide(
                  color: Colors.blue.shade300,
                  width: 1.5.w,
                ),
              ),

              errorBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14.r),

                borderSide:
                BorderSide(
                  color: Colors.red,
                ),
              ),

              focusedErrorBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14.r),

                borderSide:
                BorderSide(
                  color: Colors.red,
                  width: 1.5.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}