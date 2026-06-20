import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../manager/provider_details_cubit.dart';
import '../../../manager/state/provider_state.dart';


class AboutProviderCard extends StatelessWidget {
  const AboutProviderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderCubit, ProviderState>(
      builder: (context, state) {

        /// 🔹 Loading
        if (state is ProviderLoading) {
          return Center(child: CircularProgressIndicator());
        }

        /// 🔹 Error
        if (state is ProviderError) {
          return Text("Error loading provider data");
        }

        /// 🔹 Success
        if (state is ProviderLoaded) {
          final p = state.provider;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "About Provider",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Color(0xFF374151),
                ),
              ),

              SizedBox(height: 10.h),

              /// 🔹 Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12.r,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// 🔹 Description
                    Text(
                      p.description,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Color(0xFF6B7280),
                        height: 1.5.h,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    /// 🔹 Stats
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Color(0xFFEFF2F6),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          Column(
                            children: [
                              Text(
                                '5+ years',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text("Experience",
                                  style: TextStyle(fontSize: 12.sp)),
                            ],
                          ),

                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    Divider(),

                    SizedBox(height: 12.h),

                    /// 🔹 Contact
                    Text("Contact Information",
                        style: TextStyle(fontWeight: FontWeight.bold)),

                    SizedBox(height: 10.h),

                    _contactItem(Icons.phone, p.phone),
                    _contactItem(Icons.email, p.email),
                  ],
                ),
              ),
            ],
          );
        }

        return SizedBox();
      },
    );
  }

  Widget _item(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(Icons.verified_outlined, size: 16.r, color: Colors.blue),
          SizedBox(width: 8.w),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _contactItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 16.r, color: Colors.blue),
          SizedBox(width: 8.w),
          Text(text),
        ],
      ),
    );
  }
}