import 'package:ehtemam_final_project/features/rating_caregiver/ui/screens/rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/mytask_cg_booking_model.dart';
import '../../manager/mytask_cg_cubit.dart';

class MytaskCgCheckinBar extends StatelessWidget {
  final MytaskCgBookingModel booking;

  const MytaskCgCheckinBar({super.key, required this.booking});

  String _shortId(String id) {
    if (id.startsWith('#') || id.length <= 10) return id;
    return '#BK${id.substring(id.length - 5).toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MytaskCgCubit>();
    final canCheckOut = booking.isCheckedIn && booking.allTasksHaveProof;

    return Container(
      margin: EdgeInsets.only(left: 8.w, right: 8.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF3A8BD7),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: short booking ID + task count
          Row(
            children: [
              Expanded(
                child: Text(
                  'Booking ${_shortId(booking.bookingId)}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '${booking.completedTasks}/${booking.totalTasks}',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          // Sub-row: client name + category
          Row(
            children: [
              Icon(Icons.person_outline, size: 13.r, color: Colors.white),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  booking.clientName.isNotEmpty
                      ? '${booking.clientName}  •  ${booking.category}'
                      : booking.category,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                ),
              ),
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
                      Text(
                        ' Checked In',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.blue, size: 13.r),
                      Text(
                        ' ${booking.checkInTime ?? '—'}',
                        style: TextStyle(color: Colors.blue, fontSize: 12.sp),
                      ),
                      SizedBox(width: 12.w),
                      Icon(Icons.location_on, color: Colors.blue, size: 13.r),
                      Text(
                        ' Location tracked',
                        style: TextStyle(color: Colors.blue, fontSize: 12.sp),
                      ),
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
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlinedButton.icon(
                        onPressed: canCheckOut
                            ? () async {
                                final err =
                                    await cubit.checkOut(booking.bookingId);
                                if (!context.mounted) return;
                                if (err.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Checkout failed: $err'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Checked out successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RatingGiverScreen(
                                      bookingId: booking.bookingId,
                                      clientName: booking.clientName,
                                    ),
                                  ),
                                );
                              }
                            : null, // disabled until all tasks have proof
                        icon: Icon(Icons.logout,
                            size: 16.r,
                            color: canCheckOut ? Colors.white : Colors.white54),
                        label: Text(
                          'Check Out',
                          style: TextStyle(
                              color: canCheckOut
                                  ? Colors.white
                                  : Colors.white54),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: canCheckOut
                                  ? Colors.white
                                  : Colors.white38),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                      if (!booking.allTasksHaveProof) ...[
                        SizedBox(height: 4.h),
                        Center(
                          child: Text(
                            'Upload proof for all tasks before checking out',
                            style:
                                TextStyle(fontSize: 11.sp, color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  )
                : ElevatedButton.icon(
                    onPressed: () async {
                      final err = await cubit.checkIn(booking.bookingId);
                      if (!context.mounted) return;
                      if (err.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Server error: $err'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Checked in successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.login, size: 16.r, color: Colors.blue),
                    label: const Text(
                      'Check In to Start Work',
                      style: TextStyle(color: Color(0xFF1976D2)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
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
