import 'package:easy_localization/easy_localization.dart';
import 'package:ehtemam_final_project/features/booking_caregiver/ui/screens/booking_cg_screen.dart';
import 'package:ehtemam_final_project/features/requests_screen_user/ui/widgets/status_badge.dart';
import 'package:ehtemam_final_project/features/tasks/ui/screens/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../rating/ui/screens/rating_screen.dart';
import '../../../recieved_offers_screen/ui/screens/received_screen.dart';
import '../../data/model/model.dart';
import '../../data/model/request_type.dart';
import 'action_button.dart';

class RequestCardWidget extends StatefulWidget {
  final RequestModel request;

  const RequestCardWidget({super.key, required this.request});

  @override
  State<RequestCardWidget> createState() => _RequestCardWidgetState();
}

class _RequestCardWidgetState extends State<RequestCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Color(0XFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 6),
            blurRadius: 10.r,
          ),
        ],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Title + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.request.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              StatusBadge(type: widget.request.type, text: widget.request.status),
            ],
          ),

           SizedBox(height: 6.h),

          Text(widget.request.subtitle, style: TextStyle(color: Colors.grey)),

           SizedBox(height: 10.h),

          /// 🔹 Info
          _infoRow("start_date".tr(), widget.request.date),

          _infoRow("time".tr(), widget.request.time),

          if (widget.request.governorate.isNotEmpty)
            _infoRow("governorate".tr(), widget.request.governorate),

          if (widget.request.provider != null &&
              widget.request.provider!.isNotEmpty)
            _infoRow("Provider:".tr(), widget.request.provider!),

          if (widget.request.amount.isNotEmpty)
            _infoRow("amount".tr(), widget.request.amount),

           SizedBox(height: 12.h),

          /// 🔹 Buttons
          _buildButtons(widget.request.type),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildButtons(RequestType type) {
    switch (type) {
      case RequestType.pending:
        return Column(
          children: [

            /// RECEIVED OFFERS
            Container(
              width: double.infinity,

              padding: EdgeInsets.symmetric(
                vertical: 12.h,
              ),

              alignment: Alignment.center,

              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),

                borderRadius: BorderRadius.circular(12.r),
              ),

              child: Text(
                "Received Offers ${widget.request.offersCount}".tr(),

                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: 10.h),

            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    text: "View Offers".tr(),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OffersScreen(
                          requestId: widget.request.id,
                        ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(width: 10.w),

                IconButton(
                  icon: Icon(Icons.tune),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskScreen(
                          requestId: widget.request.id,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        );

      case RequestType.accepted:
        return Column(
          children: [
            Row(
              children: [

                Expanded(
                  child: ActionButton(
                    text: "View Details".tr(),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingCgScreen(
                            requestId: widget.request.id,
                            initialTab: 0,
                            bookingId: '',
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(width: 10.w),

                IconButton(
                  icon: Icon(Icons.tune),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskScreen(
                          requestId: widget.request.id,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        );

      case RequestType.completed:
        return ActionButton(
          text: "Rate Service".tr(),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RatingScreen(bookingId: '', caregiverName: '', caregiverRole: ''),
              ),
            );
          },
        );

      case RequestType.cancelled:
        return  SizedBox();
    }
  }
}
