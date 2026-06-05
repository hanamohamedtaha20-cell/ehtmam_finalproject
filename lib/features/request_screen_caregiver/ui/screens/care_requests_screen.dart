import 'package:flutter/material.dart';


import '../../../../core/widgets/filter.dart';
import '../widgets/care_request_card.dart';
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

          /// TOP SECTION
          Filter(

            selectedTab: selectedFilter,

            onTabChanged: (
                String selectedTab,
                ) {

              setState(() {

                selectedFilter =
                    selectedTab;
              });
            },
          ),

          /// CONTENT
          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.all(
                16,
              ),

              child: Column(
                children: [

                  /// STATS
                  const RequestStatsRow(),

                  const SizedBox(
                    height: 18,
                  ),

                  /// REQUESTS LIST
                  Expanded(
                    child: ListView.separated(

                      itemCount:
                      filteredRequests
                          .length,

                      separatorBuilder:
                          (_, __) =>
                      const SizedBox(
                        height: 16,
                      ),

                      itemBuilder:
                          (context, index) {

                        final request =
                        filteredRequests[
                        index];

                        return RequestCard(

                          status:
                          request[
                          "status"],

                          statusColor:
                          request[
                          "color"],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}