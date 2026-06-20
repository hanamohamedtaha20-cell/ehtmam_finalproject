import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../manager/complaints/complaints_cubit.dart';
import '../../manager/complaints/complaints_state.dart';
import '../widgets/complaint_card.dart';
import '../widgets/complaint_details_dialog.dart';

class ManageComplaintsScreen extends StatefulWidget {
  const ManageComplaintsScreen({super.key});

  @override
  State<ManageComplaintsScreen> createState() => _ManageComplaintsScreenState();
}

class _ManageComplaintsScreenState extends State<ManageComplaintsScreen> {
  late final ComplaintsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ComplaintsCubit();
    _cubit.getComplaints();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: const ManageComplaintsView(),
    );
  }
}

class ManageComplaintsView extends StatelessWidget {
  const ManageComplaintsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────
            Container(
              height: 86.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              color: Colors.white,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.maybePop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18.r,
                      color: Color(0xff334155),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manage Complaints',
                          style: TextStyle(
                            color: Color(0xff1E293B),
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Review and resolve user, caregiver\ncomplaints',
                          style: TextStyle(
                            color: Color(0xff64748B),
                            fontSize: 11.sp,
                            height: 1.25.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.refresh, color: Color(0xff334155)),
                      tooltip: 'Refresh',
                      onPressed: () => ctx.read<ComplaintsCubit>().getComplaints(),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ───────────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<ComplaintsCubit, ComplaintsState>(
                builder: (context, state) {
                  // Loading
                  if (state.status == ComplaintsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Error
                  if (state.status == ComplaintsStatus.error) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.red.shade300, size: 48.r),
                            SizedBox(height: 12.h),
                            Text(
                              state.errorMessage.isNotEmpty
                                  ? state.errorMessage
                                  : 'Failed to load complaints.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  context.read<ComplaintsCubit>().getComplaints(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff2F93E6),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Empty
                  if (state.status == ComplaintsStatus.success &&
                      state.complaints.isEmpty) {
                    return Center(
                      child: Text(
                        'No complaints found.',
                        style: TextStyle(
                          color: Color(0xff64748B),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  // List
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(18, 18, 18, 110),
                    itemCount: state.complaints.length,
                    itemBuilder: (context, index) {
                      final complaint = state.complaints[index];

                      return ComplaintCard(
                        complaint: complaint,
                        onViewDetails: () {
                          // Kick off the details API call first (emits loading).
                          context
                              .read<ComplaintsCubit>()
                              .getComplaintDetails(complaint.id);

                          showDialog(
                            context: context,
                            barrierColor:
                                Colors.black.withValues(alpha: 0.45),
                            builder: (_) => BlocProvider.value(
                              value: context.read<ComplaintsCubit>(),
                              child: const ComplaintDetailsDialog(),
                            ),
                          );
                        },
                      );
                    },
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
