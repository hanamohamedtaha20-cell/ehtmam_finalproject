import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../home_screen/ui/home_screen.dart';
import '../../data/model.dart';
import '../../data/request_type.dart';
import '../widgets/request_card_widget.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {

  String selectedTab = "All";

  final List<RequestModel> requests = [

    RequestModel(
      title: "Pet Care",
      subtitle: "Dog • 5 days",
      date: "March 15, 2026",
      amount: "2500",
      status: "Pending",
      type: RequestType.pending,
    ),

    RequestModel(
      title: "Elderly Care",
      subtitle: "3 days",
      date: "March 20, 2026",
      provider: "Fatma Medical Care",
      amount: "450",
      status: "Active",
      type: RequestType.accepted,
      offersCount: 3,
    ),

    RequestModel(
      title: "Child Care",
      subtitle: "2 days",
      date: "March 10, 2026",
      provider: "Sarah Child Services",
      amount: "2000",
      status: "Completed",
      type: RequestType.completed,
    ),

    RequestModel(
      title: "Pet Care",
      subtitle: "Cat • 7 days",
      date: "March 5, 2026",
      amount: "550",
      status: "Cancelled",
      type: RequestType.cancelled,
    ),
  ];

  List<RequestModel> get filteredRequests {

    if (selectedTab == "All") {
      return requests;
    }

    return requests.where((request) {
      return request.status == selectedTab;
    }).toList();
  }

  Widget buildTab(String title) {

    final bool isSelected = selectedTab == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withOpacity(0.1)
              : Colors.transparent,

          borderRadius: BorderRadius.circular(20),
        ),

        child: Text(
          title.tr(),
          style: TextStyle(
            color: isSelected
                ? Colors.blue
                : Colors.black87,

            fontWeight: isSelected
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: SafeArea(
        child: Column(
          children: [

            /// 🔹 Header
            Padding(
              padding: const EdgeInsets.all(16),

              child: Row(
                children: [

                   GestureDetector(
                       onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => HomeScreen(isGuest: true,),
                           ),
                         );
                       },
                       child: Icon(Icons.arrow_back)),

                   SizedBox(width: 10),

                  Text(
                    "myRequests".tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔹 Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [

                  buildTab("All"),
                  buildTab("Pending"),
                  buildTab("Active"),
                  buildTab("Completed"),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// 🔹 Requests List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: filteredRequests.length,

                itemBuilder: (context, index) {

                  final request = filteredRequests[index];

                  return RequestCardWidget(
                    request: request,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}