import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/provider_data.dart';


class NotesBox extends StatelessWidget {
  const NotesBox({
    super.key,
    required this.provider,
  });

  final ProviderModel provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔹 Title
        Text(
          "Provider Notes:",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),

        SizedBox(height: 6.h),

        /// 🔹 Box
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14.r),
          ),

          child: Text(
            provider.notes,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 13.sp,
              height: 1.4.h,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}