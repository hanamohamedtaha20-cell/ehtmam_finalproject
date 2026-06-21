import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/booking_user/ui/widgets/booking_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/booking_model_user.dart';
import 'booking_action_buttons.dart';
import 'booking_info_row.dart';
import 'package:easy_localization/easy_localization.dart';

class BookingCard extends StatelessWidget {
  final BookingModelUser booking;
final VoidCallback? onCancel;

  const BookingCard({
    super.key,
    required this.booking,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.all(8.r),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow:  [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4.r),
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6.r),

        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.title,
                      style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 15.sp, color: AppColors.textDark)),
                  Text(booking.subtitle,
                      style: TextStyle(fontFamily: "Arimo", fontSize: 12.sp, color: AppColors.textLight)),
                ],
              ),
              BookingStatusBadge(status: booking.status),
            ],
          ),
          SizedBox(height: 12.h),
          BookingInfoRow(icon: Icons.calendar_today_outlined, text: booking.date),
          SizedBox(height: 6.h),
          BookingInfoRow(icon: Icons.access_time_outlined, text: booking.time),
          SizedBox(height: 6.h),
          BookingInfoRow(icon: Icons.location_on_outlined, text: booking.location),
          SizedBox(height: 12.h),
          
          Row(
            children: [
              Text(
                booking.isPaidByBundle ? '0 EGP' : '${booking.price} EGP',
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: AppColors.textDark,
                ),
              ),
              if (booking.isPaidByBundle) ...[
                SizedBox(width: 8.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                        color: const Color(0xFF3A8BD7).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inventory_2_outlined,
                          color: const Color(0xFF3A8BD7), size: 11.r),
                      SizedBox(width: 3.w),
                      Text('paid_by_bundle'.tr(),
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 10.sp,
                          color: const Color(0xFF3A8BD7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 12.h),
          BookingActionButtons(status: booking.status,
           onCancel: onCancel, booking: booking,
),
            ],
      ),
    );
  }
}
