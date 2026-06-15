import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/map_user/ui/screens/track_caregiver_screen.dart';
import 'package:ehtemam_final_project/features/rating/data/repo/rating_repo.dart';
import 'package:ehtemam_final_project/features/rating/manager/rating_cubit.dart';
import 'package:ehtemam_final_project/features/rating/ui/screens/rating_screen.dart';
import 'package:ehtemam_final_project/features/task_progress_user/ui/screens/task_progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../requests_screen_user/ui/screens/requests_screen.dart';
import '../../data/model/booking_model_user.dart';

class BookingActionButtons extends StatelessWidget {
  final String status;
  final VoidCallback? onCancel;
  final BookingModelUser booking;


  const BookingActionButtons({super.key, required this.status, this.onCancel, required this.booking});

  @override
  Widget build(BuildContext context) {
    if (status == 'upcoming') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
          children: [
            Expanded(
              child: _FilledButton(
                label: "Track location",
                icon: Icons.location_on_outlined,
                color: AppColors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TrackCaregiverScreen(
                        caregiverName: booking.subtitle,
                        speciality:    booking.speciality,
                        phoneNumber:   booking.phone,
                        userLocation:  booking.location,
                        bookingId:     booking.id,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _FilledButton(
                label: "Tasks",
                icon: Icons.arrow_outward_outlined,
                color: AppColors.blue,
                onTap: () {
                   Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaskProgressScreen(bookingId: booking.id),
                  ),
                );
                },
              ),
            ),
          ],
        ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap:  onCancel,
            child: Center(
            child: Center(
              child:  Text(
                "Cancel Booking",
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 13.sp,
                  color: Colors.red,
                ),
              ),
            ),
          ),
       ) ],
      );
    }

   if (status == 'completed'){
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => RatingCubit(RatingRepo()),
            child: RatingScreen(
              bookingId:     booking.id,
              caregiverName: booking.subtitle,
              caregiverRole: booking.speciality,
            ),
          ),
        ),
      );
    },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFFEE685)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Text(
          "Rate the service",
          style: TextStyle(
            fontFamily: "Arimo",
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 235, 189, 6),
          ),
        ),
      ),
    ),
  );}
    

    if (status == 'cancelled') {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.orange),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RequestsScreen(),
              ),
            );
          },
          child: Center(
            child: Text(
              "Rebook",
              style: TextStyle(
                fontFamily: "Arimo",
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.orange,
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox();
  }
}
class _FilledButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final IconData? icon;

  const _FilledButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36.h,
          width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.r),
        ),
          child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 14.r),
              SizedBox(width: 4.w),
            ],
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: "Arimo",
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
  }
}