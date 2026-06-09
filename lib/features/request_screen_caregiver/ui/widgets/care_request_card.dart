import 'package:ehtemam_final_project/features/booking_caregiver/ui/screens/booking_cg_screen.dart';
import 'package:ehtemam_final_project/features/myTasks_caregiver/ui/screens/mytask_cg_screen.dart';
import 'package:ehtemam_final_project/features/rating_caregiver/ui/screens/rating_screen.dart';
import 'package:ehtemam_final_project/features/request_screen_caregiver/ui/screens/care_requests_screen.dart';
import 'package:ehtemam_final_project/features/share_location_cg/ui/screens/share_location_cg_screen.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/gradient_action_button.dart';
import '../screens/booking_details_acc.dart';

class RequestCard extends StatelessWidget {
  final String status;
  final Color statusColor;

  const RequestCard({
    super.key,
    required this.status,
    required this.statusColor,
  });

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

          /// TOP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pet Care",
                style: TextStyle(
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
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            "Dog • Golden Retriever",
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Client: gena shamel",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 18),

          _info(
            Icons.calendar_today_outlined,
            "Start: March 15, 2026",
          ),

          _info(
            Icons.access_time_outlined,
            "Duration: 5 days",
          ),

          /// LOCATION
          _info(
            Icons.location_on_outlined,
            "123 sidi beshr, Alexandria",
          ),

          /// PRICE
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "550",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          /// NOTE
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
                  "Needs daily walks and special diet",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// ACTIONS
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {

    /// PENDING
    if (status == "Pending") {
      return Column(
        children: [

          Row(
            children: [

              Expanded(
                child: GradientActionButton(
                  text: "Accept Request",
                  height: 46,
                  fontSize: 13,
                  colors: const [
                    Color(0xFF4CAF50),
                    Color(0xFF7DDE92),
                  ],
                  onTap: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookingDetailsAcc(),));},
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () {},

                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.red,
                      ),

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

          const SizedBox(height: 14),

          /// VIEW DETAILS
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingCgScreenScreen(),
                  ),
                );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "View Full Details",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      );
    }

    /// ACCEPTED
    if (status == "Accepted") {
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
                  onTap: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ShareLocationCgScreen(),
                  ),
                );

                  },
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
                      side: const BorderSide(
                        color: Colors.blue,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(18),
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

          const SizedBox(height: 14),

          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingCgScreenScreen(),
                  ),
                );

            },
            child: const Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Text(
                  "View Full Details",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      );
    }

    /// COMPLETED
    return SizedBox(
      width: double.infinity,

      child: SizedBox(
        height: 46,

        child: OutlinedButton(
          onPressed: () {
            Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RatingGiverScreen(),
                  ),
                );

          },

          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: Colors.orange,
            ),

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

  Widget _info(
      IconData icon,
      String text,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),

      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: Colors.grey,
          ),

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