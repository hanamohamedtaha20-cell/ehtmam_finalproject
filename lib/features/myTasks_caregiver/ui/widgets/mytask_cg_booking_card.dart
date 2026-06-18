import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/mytask_cg_booking_model.dart';
import 'mytask_cg_task_item.dart';

class MytaskCgBookingCard extends StatelessWidget {
  final MytaskCgBookingModel booking;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;
  final VoidCallback onAddTask;

  const MytaskCgBookingCard({
    super.key,
    required this.booking,
    required this.onCheckIn,
    required this.onCheckOut,
    required this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 2,
      child: Column(
        children: [
          _buildHeader(),
          if (!booking.isCheckedOut) _buildCheckInOutSection(),
          ...booking.tasks.map((task) => MytaskCgTaskItem(
            task: task,
            bookingId: booking.bookingId,
          )),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isCheckedIn = booking.isCheckedIn;
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isCheckedIn ? const Color(0xFF1976D2) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking ${booking.bookingId}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: isCheckedIn ? Colors.white : Colors.black,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 13.r, color: isCheckedIn ? Colors.white70 : Colors.grey),
                  Text(
                    ' ${booking.clientName}  •  ${booking.category}',
                    style: TextStyle(fontSize: 12.sp, color: isCheckedIn ? Colors.white70 : Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Tasks', style: TextStyle(fontSize: 11.sp, color: isCheckedIn ? Colors.white70 : Colors.grey)),
              Text(
                '${booking.completedTasks}/${booking.totalTasks}',
                style: TextStyle(fontWeight: FontWeight.bold, color: isCheckedIn ? Colors.white : Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

 Widget _buildCheckInOutSection() {
  if (booking.isCheckedIn) {
    return Container(
      margin: EdgeInsets.all(12.r),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 16.r),
              Text(' Checked In', style: TextStyle(color: Colors.green, fontSize: 13.sp, fontWeight: FontWeight.bold)),
              Spacer(),
              Icon(Icons.access_time, size: 13.r, color: Colors.grey),
              Text(' ${booking.checkInTime ?? '—'}', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue, size: 13.r),
              Text(' Location tracked', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
            ],
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onCheckOut,
              icon: Icon(Icons.logout, size: 16.r),
              label: Text('Check Out'),
              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF1976D2)),
            ),
          ),
        ],
      ),
    );
  }
  return Padding(
    padding: EdgeInsets.all(12.r),
    child: Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onCheckIn,
            icon: Icon(Icons.login, size: 16.r),
            label: Text('Check In to Start Work'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text('You must check in before completing tasks',
            style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
      ],
    ),
  );
}}