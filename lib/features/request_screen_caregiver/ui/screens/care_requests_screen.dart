import 'package:flutter/material.dart';


import '../../../../core/widgets/filter.dart';
import '../widgets/care_request_card.dart';
import '../widgets/care_request_header.dart';
import '../widgets/care_request_stats_row.dart';

class CareRequestsScreen extends StatefulWidget {
  const CareRequestsScreen({super.key});

  @override
  State<CareRequestsScreen> createState() =>
      _CareRequestsScreenState();
}

class _CareRequestsScreenState
    extends State<CareRequestsScreen> {

  String selectedFilter = "All";

  final List<Map<String, dynamic>> requests = [

    {
      "status": "Pending",
      "color": const Color(0xFFFFC857),
    },

    {
      "status": "Accepted",
      "color": const Color(0xFF4A90E2),
    },

    {
      "status": "Completed",
      "color": const Color(0xFF4CAF50),
    },
  ];

  @override
  Widget build(BuildContext context) {

    final filteredRequests =
    requests.where((request) {

      if (selectedFilter == "All") {
        return true;
      }

      return request["status"] ==
          selectedFilter;

    }).toList();

    return Scaffold(
      backgroundColor:
      const Color(0xFFF5F7FB),

      body: Column(
        children: [

          const RequestHeader(),
          /// TOP SECTION
          Filter(
            selectedTab: selectedFilter,
            onTabChanged: (
                String selectedTab,
                ){

              setState(() {

                selectedFilter =
                    selectedTab;
              });
            },
          ),
      /// CONTENT
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            
          ),
          child: ListView.separated(
            itemCount: filteredRequests.length + 1,

            separatorBuilder: (_, __) =>
             SizedBox(height: 10),

            itemBuilder: (context, index) {

              /// أول عنصر = Stats
              if (index == 0) {
                return const Column(
                  children: [
                    RequestStatsRow(),
                    SizedBox(height: 10),
                  ],
                );
              }

              final request =
              filteredRequests[index - 1];

              return RequestCard(
                status: request["status"],
                statusColor:
                request["color"],
              );
            },
          ),
        ),
      ),]
      )
    );
  }
}