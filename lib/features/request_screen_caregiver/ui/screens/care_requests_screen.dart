import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/request_screen_caregiver/data/repo/repository_implementation.dart';
import 'package:ehtemam_final_project/features/request_screen_caregiver/data/model/care_request.dart';
import 'package:ehtemam_final_project/features/request_screen_caregiver/manager/care_request_cubit.dart';
import 'package:ehtemam_final_project/features/request_screen_caregiver/manager/state/care_request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/filter.dart';
import '../widgets/care_request_card.dart';
import '../widgets/care_request_header.dart';
import '../widgets/care_request_stats_row.dart';

class CareRequestsScreen extends StatelessWidget {
  const CareRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CareRequestsCubit(
        CareRequestsRepositoryImpl(ApiService()),
      )..getAllRequests(),
      child: const CareRequestsView(),
    );
  }
}

class CareRequestsView extends StatefulWidget {
  const CareRequestsView({super.key});

  @override
  State<CareRequestsView> createState() => _CareRequestsViewState();
}

class _CareRequestsViewState extends State<CareRequestsView> {
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Column(
        children: [
          Row(
            children: [
              const Expanded(child: RequestHeader()),
              Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.black),
                  tooltip: 'Refresh',
                  onPressed: () => ctx.read<CareRequestsCubit>().getAllRequests(),
                ),
              ),
            ],
          ),
          Filter(
            selectedTab: selectedFilter,
            onTabChanged: (String selectedTab) {
              setState(() => selectedFilter = selectedTab);
            },
          ),
          Expanded(
            child: BlocBuilder<CareRequestsCubit, CareRequestsState>(
              builder: (context, state) {
                if (state is CareRequestsLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is CareRequestsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        SizedBox(height: 12.h),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<CareRequestsCubit>().getAllRequests(),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is! CareRequestsLoaded) {
                  return SizedBox.shrink();
                }

                final allRequests = state.requests;
                final pendingCount =
                    allRequests.where((r) => r.status == 'Pending').length;
                final activeCount =
                    allRequests.where((r) => r.status == 'Accepted').length;
                final completedCount =
                    allRequests.where((r) => r.status == 'Completed').length;

                final filteredRequests = allRequests.where((request) {
                  if (selectedFilter == "All") return true;
                  return request.status == selectedFilter;
                }).toList();

                if (filteredRequests.isEmpty) {
                  return Center(child: Text('No requests found'));
                }

                return Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: ListView.separated(
                    itemCount: filteredRequests.length + 1,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            RequestStatsRow(
                              pendingCount: pendingCount,
                              activeCount: activeCount,
                              completedCount: completedCount,
                            ),
                            SizedBox(height: 10.h),
                          ],
                        );
                      }

                      final request = filteredRequests[index - 1];
                      final cubit = context.read<CareRequestsCubit>();

                      return RequestCard(
                        request: request,
                        onAccept: request.sourceType ==
                                CareRequestSource.request
                            ? () => cubit.respondToRequest(
                                  requestId: request.id,
                                  action: 'ACCEPT',
                                )
                            : null,
                        onDecline: request.sourceType ==
                                CareRequestSource.request
                            ? () => cubit.respondToRequest(
                                  requestId: request.id,
                                  action: 'REJECT',
                                )
                            : null,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
