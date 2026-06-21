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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

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
            return Center(child: CircularProgressIndicator());
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
                    requestsToday: state.isAvailable ? state.requestsToday : 0,
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
                    pendingCount: state.isAvailable ? state.pendingCount : 0,
                  ),
                ),
                if (!state.isAvailable)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                      child: Center(
                        child: Text('currently_unavailable'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF667085),
                          ),
                        ),
                      ),
                    ),
                  )
                else if (state.pendingRequests.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                      child: Center(
                        child: Text(
                          state.errorMessage ?? 'No pending requests right now',
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
                        final visibleRequests = state.pendingRequests.take(2).toList();
                        final request = visibleRequests[index];
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
                      childCount: state.pendingRequests.length.clamp(0, 2),
                    ),
                  ),
                // Active Bookings section — always visible
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 4.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A8BD7),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text('active_bookings'.tr(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0B2B5A),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A8BD7),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            '${state.acceptedBookings.length}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.acceptedBookings.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                      child: Column(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 48.r,
                            color: Color(0xFFBFCDD9),
                          ),
                          SizedBox(height: 12.h),
                          Text('no_active_bookings'.tr(),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
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
                            margin: EdgeInsets.fromLTRB(16, 0, 16, 14),
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: const Color(0xFF3A8BD7).withValues(alpha: 0.3)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 8.r,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48.w,
                                  height: 48.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF4FF),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.medical_services_outlined,
                                    color: Color(0xFF3A8BD7),
                                    size: 24.r,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        booking.serviceName,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF0B2B5A),
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        booking.clientName.isNotEmpty
                                            ? 'Client: ${booking.clientName}'
                                            : booking.date,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13.sp,
                                          color: Color(0xFF667085),
                                        ),
                                      ),
                                      if (booking.date.isNotEmpty) ...[
                                        SizedBox(height: 2.h),
                                        Text(
                                          booking.date,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 12.sp,
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
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF3A8BD7),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                      decoration: BoxDecoration(
                                        color: booking.status == 'Completed'
                                            ? const Color(0xFFE8F5E9)
                                            : const Color(0xFFEAF4FF),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Text(
                                        booking.status,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: booking.status == 'Completed'
                                              ? const Color(0xFF2E7D32)
                                              : const Color(0xFF3A8BD7),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 4.w),
                                Icon(Icons.chevron_right, color: Color(0xFF98A2B3)),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: state.acceptedBookings.length,
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: 100.h)),
              ],
            ),
          );
        },
      ),
    );
  }
}
