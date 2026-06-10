import 'package:ehtemam_final_project/features/booking_caregiver/ui/screens/booking_cg_screen.dart';
import 'package:ehtemam_final_project/features/homescreen_caregiver/manager/hc_cubit.dart';
import 'package:ehtemam_final_project/features/homescreen_caregiver/manager/hc_state.dart';
import 'package:ehtemam_final_project/features/request_screen_caregiver/data/model/care_request.dart';
import 'package:ehtemam_final_project/features/homescreen_caregiver/ui/widgets/hc_availability_card.dart';
import 'package:ehtemam_final_project/features/homescreen_caregiver/ui/widgets/hc_header_section.dart';
import 'package:ehtemam_final_project/features/homescreen_caregiver/ui/widgets/hc_pending_requests_header.dart';
import 'package:ehtemam_final_project/features/homescreen_caregiver/ui/widgets/hc_request_card.dart';
import 'package:ehtemam_final_project/features/homescreen_caregiver/ui/widgets/hc_stats_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HcHomeScreen extends StatelessWidget {
  const HcHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HcCubit()..loadDashboard(),
      child: const _HcHomeView(),
    );
  }
}

class _HcHomeView extends StatelessWidget {
  const _HcHomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: BlocBuilder<HcCubit, HcState>(
        builder: (context, state) {
          if (state.isLoading && state.pendingRequests.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => context.read<HcCubit>().loadDashboard(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: HcHeaderSection(businessTitle: state.businessTitle),
                ),
                SliverToBoxAdapter(
                  child: HcStatsGrid(
                    requestsToday: state.requestsToday,
                    earningsThisWeek: state.earningsThisWeek,
                    rating: state.rating,
                    activeHours: state.activeHours,
                  ),
                ),
                SliverToBoxAdapter(
                  child: HcAvailabilityCard(
                    isAvailable: state.isAvailable,
                    onChanged: context.read<HcCubit>().toggleAvailability,
                  ),
                ),
                SliverToBoxAdapter(
                  child: HcPendingRequestsHeader(
                    pendingCount: state.pendingCount,
                  ),
                ),
                if (state.pendingRequests.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: Center(
                        child: Text(
                          state.errorMessage ?? 'No pending requests right now',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF667085),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final request = state.pendingRequests[index];
                        final cubit = context.read<HcCubit>();

                        return HcRequestCard(
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
                          onViewDetails: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingCgScreenScreen(
                                  requestId: request.id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: state.pendingRequests.length,
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          );
        },
      ),
    );
  }
}
