import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BundlesCard extends StatelessWidget {
  final VoidCallback onTap;

  const BundlesCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 3.w,
      ),

      padding:  EdgeInsets.all(15.r),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),

        gradient:  LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            Color(0xFF4A90E2),
            Color(0xFF7DBAF5),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6.r,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          /// TOP SECTION
          Row(
            children: [
              /// ICON BOX
              Container(
                width: 55.w,
                height: 55.h,

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),

                  borderRadius:
                  BorderRadius.circular(20.r),
                ),

                child:  Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.white,
                  size: 25.r,
                ),
              ),

              SizedBox(width: 13.w),

              /// TEXTS
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children:[
                    Text(
                      "Save with Bundles",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      "Get up to 40% off with service packages",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        height: 1.35.h,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          /// BUTTON
          InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: onTap,

            child: Container(
              height: 45.h,

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(16.r),

                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withOpacity(0.3),
                    blurRadius: 6.r,
                    offset: Offset(0, 2),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    color: Color(0xFF00A86B),
                    size: 20.r,
                  ),

                  SizedBox(width: 9.w),

                  Text(
                    "View Bundles",

                    style: TextStyle(
                      color: Color(0xFF00A86B),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}