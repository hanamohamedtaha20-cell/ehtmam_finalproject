import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../manager/complaints/complaints_cubit.dart';
import '../../manager/complaints/complaints_state.dart';
import '../widgets/complaint_card.dart';
import '../widgets/complaint_details_dialog.dart';

class ManageComplaintsScreen extends StatelessWidget {
  const ManageComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ComplaintsCubit()..getComplaints(),
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
            Container(
              height: 86.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              color: Colors.white,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.maybePop(context);
                    },
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
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<ComplaintsCubit, ComplaintsState>(
                builder: (context, state) {
                  if (state.status == ComplaintsStatus.loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.status == ComplaintsStatus.error) {
                    return Center(
                      child: Text(
                        state.errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  if (state.complaints.isEmpty) {
                    return Center(
                      child: Text(
                        'No complaints found',
                        style: TextStyle(
                          color: Color(0xff64748B),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(18, 18, 18, 110),
                    itemCount: state.complaints.length,
                    itemBuilder: (context, index) {
                      final complaint = state.complaints[index];

                      return ComplaintCard(
                        complaint: complaint,
                        onViewDetails: () {
                          showDialog(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.45),
                            builder: (_) {
                              return ComplaintDetailsDialog(
                                complaint: complaint,
                              );
                            },
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