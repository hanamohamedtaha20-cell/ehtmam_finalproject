import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClientInfoCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final double rating;

  const ClientInfoCard({
    super.key,
    this.name = '',
    this.phone = '',
    this.email = '',
    this.rating = 0,
  });

  @override
  Widget build(BuildContext context) {
    final ratingText =
        rating > 0 ? '$rating rating' : 'No rating yet';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 6),
            blurRadius: 8.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                color: Color(0xff44516B),
                size: 18.r,
              ),
              SizedBox(width: 8.w),
              Text(
                "CLIENT INFORMATION",
                style: TextStyle(
                  color: Color(0xff44516B),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.h,
                width: 50.w,
                decoration: BoxDecoration(
                  color: const Color(0xff169CE8),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 6),
                      blurRadius: 8.r,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 24.r,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isNotEmpty ? name : 'Client',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1E2A44),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Color(0xff3D87D9),
                          size: 16.r,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          ratingText,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (phone.isNotEmpty) ...[
            SizedBox(height: 15.h),
            Row(
              children: [
                Icon(
                  Icons.call_outlined,
                  color: Color(0xff2F80ED),
                  size: 20.r,
                ),
                SizedBox(width: 10.w),
                Text(
                  phone,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          if (email.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.mail_outline,
                  color: Color(0xff2F80ED),
                  size: 20.r,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    email,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
