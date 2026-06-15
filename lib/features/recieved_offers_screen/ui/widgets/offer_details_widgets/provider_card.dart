import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../manager/provider_details_cubit.dart';
import '../../../manager/state/provider_state.dart';



class ProviderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderCubit, ProviderState>(
      builder: (context, state) {

        /// Loading
        if (state is ProviderLoading) {
          return Center(child: CircularProgressIndicator());
        }

        /// Error
        if (state is ProviderError) {
          return Text("Error");
        }

        /// Success
        if (state is ProviderLoaded) {
          final p = state.provider;

          return Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3A8BD7),
                  Color(0xFF3A8BD7),
                  Color(0xFFFFFFFF),
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10.r,
                  offset: Offset(0, 10),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔹 Top Row
                Row(
                  children: [

                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Color(0xFF8FB9EC),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10.r,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text("👩‍🦱", style: TextStyle(fontSize: 28.sp)),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// 👇 بدل static
                          Text(
                            p.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4.h),

                          Text(
                            p.service,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13.sp,
                            ),
                          ),

                          SizedBox(height: 8.h),

                          Row(
                            children: [

                              _badge(
                                icon: Icons.star,
                                text: "${p.rating} (${p.reviewsCount} Reviews)",
                                color: Colors.white,
                                bg: Colors.white.withOpacity(0.2),
                              ),

                              SizedBox(width: 6.w),

                              if (p.isVerified)
                                _badge(
                                  icon: Icons.verified_outlined,
                                  text: "Verified",
                                  color: Colors.white,
                                  bg: Colors.white.withOpacity(0.2),
                                ),
                            ],
                          ),

                          SizedBox(height: 6.h),

                          if (p.isCertified)
                            _badge(
                              icon: Icons.workspace_premium_outlined,
                              text: "Certified",
                              color: Colors.white,
                              bg: Colors.white.withOpacity(0.2),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                Container(
                  height: 1.h,
                  color: Colors.white.withOpacity(0.3),
                ),

                SizedBox(height: 12.h),

                /// 🔹 Bottom Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Proposed Price",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.sp,
                          ),
                        ),

                        SizedBox(height: 4.h),

                        Row(
                          children: [
                            if (p.oldPrice > 0) ...[
                              Text(
                                "${p.oldPrice.toStringAsFixed(0)} EGP",
                                style: TextStyle(
                                  color: Colors.white70,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(width: 6.w),
                            ],
                            Text(
                              "${p.price.toStringAsFixed(0)} EGP",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (p.hourlyRate > 0) ...[
                          SizedBox(height: 4.h),
                          Text(
                            "${p.hourlyRate.toStringAsFixed(0)} EGP / hr",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ],
                    ),

                    if (p.location.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Location",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            p.location,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          );
        }

        return SizedBox();
      },
    );
  }

  Widget _badge({
    required IconData icon,
    required String text,
    required Color color,
    required Color bg,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.r, color: color),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}