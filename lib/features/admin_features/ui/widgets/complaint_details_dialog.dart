import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/complaint_details_model.dart';
import '../../manager/complaints/complaints_cubit.dart';
import '../../manager/complaints/complaints_state.dart';

class ComplaintDetailsDialog extends StatelessWidget {
  const ComplaintDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplaintsCubit, ComplaintsState>(
      builder: (context, state) {
        // ── Loading ──────────────────────────────────────────────────────
        if (state.detailsStatus == DetailsStatus.loading ||
            state.detailsStatus == DetailsStatus.idle) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
            backgroundColor: Colors.transparent,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 360),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _header(context),
                  SizedBox(height: 48.h),
                  const CircularProgressIndicator(),
                  SizedBox(height: 48.h),
                ],
              ),
            ),
          );
        }

        // ── Error ────────────────────────────────────────────────────────
        if (state.detailsStatus == DetailsStatus.error) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
            backgroundColor: Colors.transparent,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 360),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _header(context),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 28),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.red.shade300, size: 44.r),
                        SizedBox(height: 12.h),
                        Text(
                          state.detailsErrorMessage.isNotEmpty
                              ? state.detailsErrorMessage
                              : 'Failed to load complaint details.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        SizedBox(
                          width: double.infinity,
                          height: 38.h,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff2F93E6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: Text('Close',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700)),
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

        // ── Loaded ───────────────────────────────────────────────────────
        final d = state.details;
        if (d == null) return const SizedBox.shrink();
        return _buildDetails(context, d);
      },
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Color(0xff2F93E6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.r),
          topRight: Radius.circular(18.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Complaint Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.close, color: Colors.white, size: 20.r),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context, ComplaintDetailsModel d) {
    final statusLower = d.status.toLowerCase();
    final isResolved = statusLower == 'resolved' || statusLower == 'closed';

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(context),
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: isResolved
                          ? const Color(0xffDCFCE7)
                          : const Color(0xffFEF3C7),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      d.status,
                      style: TextStyle(
                        color: isResolved
                            ? const Color(0xff16A34A)
                            : const Color(0xffF59E0B),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Complaint ID
                  _detailRow(label: 'Complaint ID', value: d.complaintId),

                  SizedBox(height: 14.h),

                  // Subject
                  Text(
                    d.subject,
                    style: TextStyle(
                      color: Color(0xff1E293B),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.25.h,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Client + Caregiver info card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: const Color(0xffF8FAFC),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _detailRow(label: 'Client', value: d.clientName),
                        SizedBox(height: 4.h),
                        _detailRow(label: 'Client Email', value: d.clientEmail),
                        SizedBox(height: 10.h),
                        _detailRow(label: 'Caregiver', value: d.caregiverName),
                        SizedBox(height: 4.h),
                        _detailRow(label: 'Caregiver Email', value: d.caregiverEmail),
                        SizedBox(height: 10.h),
                        _detailRow(label: 'Category', value: d.complaintCategory),
                        SizedBox(height: 4.h),
                        _detailRow(label: 'Booking ID', value: d.bookingId),
                        SizedBox(height: 10.h),
                        _detailRow(label: 'Created', value: d.formattedCreatedAt),
                        SizedBox(height: 4.h),
                        _detailRow(label: 'Updated', value: d.formattedUpdatedAt),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Message
                  Text(
                    'Message',
                    style: TextStyle(
                      color: Color(0xff334155),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(13.r),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFBEA),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xffFACC15)),
                    ),
                    child: Text(
                      d.message,
                      style: TextStyle(
                        color: Color(0xff334155),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.35.h,
                      ),
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

  Widget _detailRow({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xff64748B),
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value.isNotEmpty ? value : '—',
          style: TextStyle(
            color: Color(0xff1E293B),
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
