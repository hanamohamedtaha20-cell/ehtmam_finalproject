import 'package:ehtemam_final_project/features/booking_caregiver/ui/screens/booking_cg_screen.dart';
import 'package:ehtemam_final_project/features/myTasks_caregiver/ui/screens/mytask_cg_screen.dart';
import 'package:ehtemam_final_project/features/request_screen_caregiver/data/model/care_request.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/gradient_action_button.dart';

class RequestCard extends StatelessWidget {
  final CareRequestModel request;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const RequestCard({
    super.key,
    required this.request,
    this.onAccept,
    this.onDecline,
  });

  Color get statusColor {
    switch (request.status) {
      case 'Pending':
        return const Color(0xFFFFC857);
      case 'Accepted':
        return const Color(0xFF4A90E2);
      case 'Completed':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFFFFC857);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                request.serviceName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  request.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          if (request.duration.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              request.duration,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
          if (request.clientName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              "Client: ${request.clientName}",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: 18),
          if (request.date.isNotEmpty)
            _info(Icons.calendar_today_outlined, "Start: ${request.date}"),
          if (request.duration.isNotEmpty)
            _info(Icons.access_time_outlined, "Duration: ${request.duration}"),
          if (request.location.isNotEmpty)
            _info(Icons.location_on_outlined, request.location),
          if (request.price.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                request.price,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (request.notes.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    request.notes,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    if (request.status == "Pending") {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GradientActionButton(
                  text: "View Details",
                  height: 46,
                  fontSize: 13,
                  colors: const [
                    Color(0xFF4CAF50),
                    Color(0xFF7DDE92),
                  ],
                  onTap: () => _openBookingDetails(context),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed: onDecline,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      "Decline",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (request.status == "Accepted") {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GradientActionButton(
                  text: "Share Location",
                  height: 46,
                  fontSize: 13,
                  colors: const [
                    Color(0xFF4CAF50),
                    Color(0xFF7DDE92),
                  ],
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MytaskCgScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      "View Tasks",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: SizedBox(
        height: 46,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.orange),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Text(
            "Rate Client",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _openBookingDetails(BuildContext context, {int initialTab = 0}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingCgScreen(
          requestId: request.id,
          initialTab: initialTab,
          bookingId: request.bookingId ?? '',
        ),
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 17, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
