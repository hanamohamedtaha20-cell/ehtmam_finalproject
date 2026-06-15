import 'package:ehtemam_final_project/features/rating_caregiver/ui/screens/rating_screen.dart';
import 'package:flutter/material.dart';
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
      margin: EdgeInsets.only(left: 8, right: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:  const Color(0xFF3A8BD7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              
              const SizedBox(width: 8),
              Text(
                'Booking ${booking.bookingId}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 12,
                  color: booking.isCheckedIn ? Colors.white : Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.person_outline, size: 13, color: booking.isCheckedIn ? Colors.white : Colors.white),
              Expanded(child:
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  
                  Text(
                    ' ${booking.clientName}  •  ${booking.category}',
                    style: TextStyle(fontSize: 12, color: booking.isCheckedIn ? Colors.white : Colors.white),
                  ),
              
                  Text('${booking.completedTasks}/${booking.totalTasks}',
                    style: TextStyle(fontSize: 18, color: Colors.white , fontWeight: FontWeight.bold),),
                ],
              ),),
            ],
          ),
          if (booking.isCheckedIn) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 14),
                        const Text(' Checked In', style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.blue, size: 13),
                        Text(' ${booking.checkInTime}', style: const TextStyle(color: Colors.blue, fontSize: 12)),
                        const SizedBox(width: 12),
                        const Icon(Icons.location_on, color: Colors.blue, size: 13),
                        const Text(' Location tracked', style: TextStyle(color: Colors.blue, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: booking.isCheckedIn
                ? OutlinedButton.icon(
                    onPressed: () async {
                      final success = await cubit.checkOut(booking.bookingId);
                      if (!context.mounted) return;
                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
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
                    icon: const Icon(Icons.logout, size: 16, color: Colors.white),
                    label: const Text('Check Out', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: () async => cubit.checkIn(booking.bookingId),
                    icon: const Icon(Icons.login, size: 16,color: Colors.blue,),
                    label: const Text('Check In to Start Work',style: TextStyle(color: Color(0xFF1976D2))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.white,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
          ),
          if (!booking.isCheckedIn)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Center(
                child: Text(
                  'You must check in before completing tasks',
                  style: TextStyle(fontSize: 11, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}