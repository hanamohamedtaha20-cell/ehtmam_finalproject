import 'package:ehtemam_final_project/features/booking_caregiver/ui/screens/booking_cg_screen.dart';
import 'package:ehtemam_final_project/features/myTasks_caregiver/ui/screens/mytask_cg_screen.dart';
import 'package:ehtemam_final_project/features/rating_caregiver/ui/screens/rating_screen.dart';
import 'package:ehtemam_final_project/features/request_screen_caregiver/data/model/care_request.dart';
import 'package:ehtemam_final_project/features/share_location_cg/ui/screens/share_location_cg_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10.r,
            offset: Offset(0, 4),
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
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  request.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          if (request.duration.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              request.duration,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
          if (request.clientName.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              "Client: ${request.clientName}",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14.sp,
              ),
            ),
          ],
          SizedBox(height: 18.h),
          if (request.date.isNotEmpty)
            _info(Icons.calendar_today_outlined, "Start: ${request.date}"),
          if (request.duration.isNotEmpty)
            _info(Icons.access_time_outlined, "Duration: ${request.duration}"),
          if (request.location.isNotEmpty)
            _info(Icons.location_on_outlined, request.location),
          if (request.price.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(
                request.price,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (request.notes.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 18.r,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    request.notes,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: 20.h),
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
                  height: 46.h,
                  fontSize: 13.sp,
                  colors: [
                    Color(0xFF4CAF50),
                    Color(0xFF7DDE92),
                  ],
                  onTap: () => _openBookingDetails(context),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: SizedBox(
                  height: 46.h,
                  child: OutlinedButton(
                    onPressed: onDecline,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    ),
                    child: Text(
                      "Decline",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 13.sp,
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
                  height: 46.h,
                  fontSize: 13.sp,
                  colors: const [Color(0xFF4CAF50), Color(0xFF7DDE92)],
                  onTap: () {
                    final bid = request.bookingId ?? '';
                    debugPrint('CAREGIVER_BOOKING_ID = $bid');
                    if (bid.isEmpty) {
                      // bookingId is null when this card was built from a raw
                      // request (fromRequestJson) instead of a booking document.
                      // Prevent navigating with an empty ID — nothing would be
                      // sent to the backend and the caregiver would see a false
                      // "Sharing location" state.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Booking not ready yet. Please wait and refresh.',
                          ),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ShareLocationCgScreen(
                          bookingId: bid,
                          clientName: request.clientName,
                          serviceType: request.serviceName,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: SizedBox(
                  height: 46.h,
                  child: OutlinedButton(
                    onPressed: () async {
                      final bookingId = request.bookingId ?? '';
                      final prefs = await SharedPreferences.getInstance();
                      final locationShared =
                          prefs.getBool('loc_shared_$bookingId') ?? false;
                      if (!context.mounted) return;
                      if (!locationShared) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'You must share your location first before viewing tasks.',
                            ),
                          ),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MytaskCgScreen(
                            bookingId: request.bookingId,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    ),
                    child: Text(
                      "View Tasks",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 13.sp,
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
        height: 46.h,
        child: OutlinedButton(
          onPressed: () {
            final bookingId = request.bookingId ?? '';
            if (bookingId.isEmpty) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RatingGiverScreen(
                  bookingId: bookingId,
                  clientName: request.clientName,
                ),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.orange),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.r),
            ),
          ),
          child: Text(
            "Rate Client",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 13.sp,
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
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Icon(icon, size: 17.r, color: Colors.grey),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
