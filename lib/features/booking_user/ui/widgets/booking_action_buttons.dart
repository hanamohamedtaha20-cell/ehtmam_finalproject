import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/map_user/ui/screens/track_caregiver_screen.dart';
import 'package:ehtemam_final_project/features/rating/data/repo/rating_repo.dart';
import 'package:ehtemam_final_project/features/rating/manager/rating_cubit.dart';
import 'package:ehtemam_final_project/features/rating/ui/screens/rating_screen.dart';
import 'package:ehtemam_final_project/features/task_progress_user/ui/screens/task_progress_screen.dart';
import 'package:flutter/material.dart';
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
            const SizedBox(width: 8),
            Expanded(
              child: _FilledButton(
                label: "Tasks",
                icon: Icons.arrow_outward_outlined,
                color: AppColors.blue,
                onTap: () {
                   Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TaskProgressScreen(),
                  ),
                );
                },
              ),
            ),
          ],
        ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap:  onCancel,
            child: const Center(
            child: Center(
              child:  Text(
                "Cancel Booking",
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 13,
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
              caregiverId: '',
              serviceId: '',
              requestId: '',
              caregiverName: '',
              caregiverRole: '',
            ),
          ),
        ),
      );
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFFEE685)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          "Rate the service",
          style: TextStyle(
            fontFamily: "Arimo",
            fontSize: 12,
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.orange),
          borderRadius: BorderRadius.circular(8),
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
          child: const Center(
            child: Text(
              "Rebook",
              style: TextStyle(
                fontFamily: "Arimo",
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.orange,
              ),
            ),
          ),
        ),
      );
    }

    return const SizedBox();
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
        height: 36,
          width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
          child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 14),
              const SizedBox(width: 4),
            ],
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: "Arimo",
                    fontSize: 13,
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