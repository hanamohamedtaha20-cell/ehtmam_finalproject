import 'package:ehtemam_final_project/features/myTasks_caregiver/manager/mytask_cg_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Column(
        children: [
          _buildHeader(),
          if (!booking.isCheckedOut) _buildCheckInOutSection(),
          ...booking.tasks.map((task) => Builder(
      builder: (context) => MytaskCgTaskItem(
        task: task,
        bookingId: booking.bookingId,
        onAddProof: () => context.read<MytaskCgCubit>().addMediaToTask(booking.bookingId, task.id),
      ),
    )),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isCheckedIn = booking.isCheckedIn;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCheckedIn ? const Color(0xFF1976D2) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                  fontSize: 15,
                  color: isCheckedIn ? Colors.white : Colors.black,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 13, color: isCheckedIn ? Colors.white70 : Colors.grey),
                  Text(
                    ' ${booking.clientName}  •  ${booking.category}',
                    style: TextStyle(fontSize: 12, color: isCheckedIn ? Colors.white70 : Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Tasks', style: TextStyle(fontSize: 11, color: isCheckedIn ? Colors.white70 : Colors.grey)),
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
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 16),
              const Text(' Checked In', style: TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.access_time, size: 13, color: Colors.grey),
              Text(' ${booking.checkInTime}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.blue, size: 13),
              const Text(' Location tracked', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onCheckOut,
              icon: const Icon(Icons.logout, size: 16),
              label: const Text('Check Out'),
              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF1976D2)),
            ),
          ),
        ],
      ),
    );
  }
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onCheckIn,
            icon: const Icon(Icons.login, size: 16),
            label: const Text('Check In to Start Work'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text('You must check in before completing tasks',
            style: TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    ),
  );
}}