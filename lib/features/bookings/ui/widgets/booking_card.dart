import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/bookings/data/model/booking_model.dart';
import 'package:ehtemam_final_project/features/bookings/ui/widgets/booking_action_buttons.dart';
import 'package:ehtemam_final_project/features/bookings/ui/widgets/booking_info_row.dart';
import 'package:ehtemam_final_project/features/bookings/ui/widgets/booking_status_badge.dart';
import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4),
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6),
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
                      style: const TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark)),
                  Text(booking.subtitle,
                      style: const TextStyle(fontFamily: "Arimo", fontSize: 12, color: AppColors.textLight)),
                ],
              ),
              BookingStatusBadge(status: booking.status),
            ],
          ),
          const SizedBox(height: 12),
          BookingInfoRow(icon: Icons.calendar_today_outlined, text: booking.date),
          const SizedBox(height: 6),
          BookingInfoRow(icon: Icons.access_time_outlined, text: booking.time),
          const SizedBox(height: 6),
          BookingInfoRow(icon: Icons.location_on_outlined, text: booking.location),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(booking.price.toString(),
                  style: const TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
              BookingActionButtons(status: booking.status),
            ],
          ),
        ],
      ),
    );
  }
}