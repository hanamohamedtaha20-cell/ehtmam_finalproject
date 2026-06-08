import 'package:easy_localization/easy_localization.dart';
import 'package:ehtemam_final_project/features/requests_screen_user/data/model/request_type.dart';
import 'package:ehtemam_final_project/features/requests_screen_user/ui/widgets/action_button.dart';
import 'package:ehtemam_final_project/features/requests_screen_user/ui/widgets/status_badge.dart';
import 'package:ehtemam_final_project/features/tasks/ui/screens/task_screen.dart';
import 'package:flutter/material.dart';
import '../../../rating/ui/screens/rating_screen.dart';
import '../../../recieved_offers_screen/ui/screens/offer_details_screen.dart';
import '../../../recieved_offers_screen/ui/screens/received_screen.dart';
import '../../data/model.dart';


class RequestCardWidget extends StatefulWidget {
  final RequestModel request;

  RequestCardWidget({super.key, required this.request});

  @override
  State<RequestCardWidget> createState() => _RequestCardWidgetState();
}

class _RequestCardWidgetState extends State<RequestCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0XFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 6),
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.circular(20),
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

           SizedBox(height: 6),

          Text(widget.request.subtitle, style: TextStyle(color: Colors.grey)),

           SizedBox(height: 10),

          /// 🔹 Info
          _infoRow("startDate:".tr(), widget.request.date),

          if (widget.request.provider != null)
            _infoRow("Provider:".tr(), widget.request.provider!),

          _infoRow("amount:".tr(), widget.request.amount),

           SizedBox(height: 12),

          /// 🔹 Buttons
          _buildButtons(widget.request.type),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 4),
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
        return Row(
          children: [
            Expanded(
              child: ActionButton(
                text: "View Offers".tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OffersScreen(),
                    ),
                  );
                },
              ),
            ),
             SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.tune),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskScreen(),
                  ),
                );
              },
            )
          ],
        );

      case RequestType.accepted:
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
            vertical: 12,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child:Text(
                "Received Offers ${widget.request.offersCount}".tr(),
                style: TextStyle(color: Colors.green),
              ),
            ),
             SizedBox(height: 10),
            Row(
              children: [

                Expanded(
                  child: ActionButton(
                    text: "View Details".tr(),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OfferDetailsScreen(),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(width: 10),

                Icon(
                  Icons.tune,
                  color: Colors.black87,
                ),
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
                builder: (context) => RatingScreen(caregiverId: '', serviceId: '', requestId: '', caregiverName: '', caregiverRole: '',),
              ),
            );
          },
        );

      case RequestType.cancelled:
        return  SizedBox();
    }
  }
}
