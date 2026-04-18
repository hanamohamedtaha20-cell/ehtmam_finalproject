import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/model.dart';
import '../../data/request_type.dart';
import '../widgets/request_card_widget.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 Header
            Padding(
              padding:  EdgeInsets.all(16),
              child: Row(
                children: [
                   Icon(Icons.arrow_back),
                   SizedBox(width: 10),
                  Text(
                    "myRequests".tr(),
                    style:  TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            /// 🔹 Tabs
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:  [
                  Text("All".tr(), style: TextStyle(color: Colors.blue)),
                  Text("Pending".tr()),
                  Text("Active".tr()),
                  Text("Completed".tr()),
                ],
              ),
            ),

             SizedBox(height: 10),

            /// 🔹 List
            Expanded(
              child: ListView(
                padding:  EdgeInsets.all(16),
                children: [
                  RequestCardWidget(
                    request: RequestModel(
                      title: "Pet Care",
                      subtitle: "Dog • 5 days",
                      date: "March 15, 2026",
                      amount: "2500",
                      status: "Pending",
                      type: RequestType.pending,
                    ),
                  ),

                  RequestCardWidget(
                    request: RequestModel(
                      title: "Elderly Care",
                      subtitle: "3 days",
                      date: "March 20, 2026",
                      provider: "Fatma Medical Care",
                      amount: "450",
                      status: "Accepted",
                      type: RequestType.accepted,
                    ),
                  ),

                  RequestCardWidget(
                    request: RequestModel(
                      title: "Child Care",
                      subtitle: "2 days",
                      date: "March 10, 2026",
                      provider: "Sarah Child Services",
                      amount: "2000",
                      status: "Completed",
                      type: RequestType.completed,
                    ),
                  ),

                  RequestCardWidget(
                    request: RequestModel(
                      title: "Pet Care",
                      subtitle: "Cat • 7 days",
                      date: "March 5, 2026",
                      amount: "550",
                      status: "Cancelled",
                      type: RequestType.cancelled,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
