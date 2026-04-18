import 'package:easy_localization/easy_localization.dart';
import 'package:ehtemam_final_project/features/offers_screen/ui/screens/offers_screen.dart';
import 'package:ehtemam_final_project/features/requests_screen/ui/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import '../../data/model.dart';
import '../../data/request_type.dart';
import 'action_button.dart';

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

          const SizedBox(height: 6),

          Text(widget.request.subtitle, style: TextStyle(color: Colors.grey)),

          const SizedBox(height: 10),

          /// 🔹 Info
          _infoRow("startDate:".tr(), widget.request.date),

          if (widget.request.provider != null)
            _infoRow("Provider:".tr(), widget.request.provider!),

          _infoRow("amount:".tr(), widget.request.amount),

          const SizedBox(height: 12),

          /// 🔹 Buttons
          _buildButtons(widget.request.type),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
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
            const SizedBox(width: 10),
            const Icon(Icons.tune),
          ],
        );

      case RequestType.accepted:
        return Column(
          children: [
            Container(
              padding:  EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Received Offers 3".tr(),
                style: TextStyle(color: Colors.green),
              ),
            ),
             SizedBox(height: 10),
            ActionButton(text: "View Details".tr(), onTap: () {  },),
          ],
        );

      case RequestType.completed:
        return ActionButton(text: "Rate Service".tr(), onTap: () {  },);

      case RequestType.cancelled:
        return  SizedBox();
    }
  }
}
