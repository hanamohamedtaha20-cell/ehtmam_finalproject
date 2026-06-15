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
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BookingCgScreen(
                                        requestId: request.id,
                                        initialTab: 0,
                                        bookingId: '',
                                      ),
                                    ),
                                  );
                                }
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
                      childCount: state.pendingRequests.length,
                    ),
                  ),
                if (state.acceptedBookings.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3A8BD7),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Active Bookings',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0B2B5A),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3A8BD7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${state.acceptedBookings.length}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final booking = state.acceptedBookings[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookingCgScreen(
                                requestId: booking.id,
                                initialTab: 1,
                                bookingId: booking.bookingId ?? '',
                              ),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF3A8BD7).withValues(alpha: 0.3)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF4FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.medical_services_outlined,
                                    color: Color(0xFF3A8BD7),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        booking.serviceName,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF0B2B5A),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        booking.clientName.isNotEmpty
                                            ? 'Client: ${booking.clientName}'
                                            : booking.date,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          color: Color(0xFF667085),
                                        ),
                                      ),
                                      if (booking.date.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          booking.date,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            color: Color(0xFF98A2B3),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      booking.price.isNotEmpty ? 'EGP ${booking.price}' : '',
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF3A8BD7),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: booking.status == 'Completed'
                                            ? const Color(0xFFE8F5E9)
                                            : const Color(0xFFEAF4FF),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        booking.status,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: booking.status == 'Completed'
                                              ? const Color(0xFF2E7D32)
                                              : const Color(0xFF3A8BD7),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right, color: Color(0xFF98A2B3)),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: state.acceptedBookings.length,
                    ),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          );
        },
      ),
    );
  }
}
