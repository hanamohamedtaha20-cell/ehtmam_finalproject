import 'package:ehtemam_final_project/features/rating_caregiver/ui/screens/rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/mytask_cg_booking_model.dart';
import '../../manager/mytask_cg_cubit.dart';

class MytaskCgCheckinBar extends StatelessWidget {
  final MytaskCgBookingModel booking;

  const MytaskCgCheckinBar({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MytaskCgCubit>();

    return Container(
      margin: EdgeInsets.only(left: 8.w, right: 8.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color:  const Color(0xFF3A8BD7),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              
              SizedBox(width: 8.w),
              Text(
                'Booking ${booking.bookingId}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: booking.isCheckedIn ? Colors.white : Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(Icons.person_outline, size: 13.r, color: booking.isCheckedIn ? Colors.white : Colors.white),
              Expanded(child:
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  
                  Text(
                    ' ${booking.clientName}  •  ${booking.category}',
                    style: TextStyle(fontSize: 12.sp, color: booking.isCheckedIn ? Colors.white : Colors.white),
                  ),
              
                  Text('${booking.completedTasks}/${booking.totalTasks}',
                    style: TextStyle(fontSize: 18.sp, color: Colors.white , fontWeight: FontWeight.bold),),
                ],
              ),),
            ],
          ),
          if (booking.isCheckedIn) ...[
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 14.r),
                        Text(' Checked In', style: TextStyle(color: Colors.blue, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.blue, size: 13.r),
                        Text(' ${booking.checkInTime}', style: TextStyle(color: Colors.blue, fontSize: 12.sp)),
                        SizedBox(width: 12.w),
                        Icon(Icons.location_on, color: Colors.blue, size: 13.r),
                        Text(' Location tracked', style: TextStyle(color: Colors.blue, fontSize: 12.sp)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: booking.isCheckedIn
                ? OutlinedButton.icon(
                    onPressed: () async {
                      final success = await cubit.checkOut(booking.bookingId);
                      if (!context.mounted) return;
                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('All tasks must have photo/video proof before checkout'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RatingGiverScreen()),
                      );
                    },
                    icon: Icon(Icons.logout, size: 16.r, color: Colors.white),
                    label: Text('Check Out', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: () async => cubit.checkIn(booking.bookingId),
                    icon: Icon(Icons.login, size: 16.r,color: Colors.blue,),
                    label: Text('Check In to Start Work',style: TextStyle(color: Color(0xFF1976D2))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.white,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ),
          ),
          if (!booking.isCheckedIn)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Center(
                child: Text(
                  'You must check in before completing tasks',
                  style: TextStyle(fontSize: 11.sp, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}