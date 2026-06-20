import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/pending_approvals/pending_approvals_cubit.dart';
import '../../manager/pending_approvals/pending_approvals_state.dart';
import '../widgets/pending_approval_card.dart';
import 'pending_documents_screen.dart';

class PendingApprovalsScreen extends StatelessWidget {
  const PendingApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PendingApprovalsCubit()..getPendingApprovals(),
      child: const PendingApprovalsView(),
    );
  }
}

class PendingApprovalsView extends StatelessWidget {
  const PendingApprovalsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(12, 10, 18, 16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => Navigator.maybePop(context),
                        icon: Icon(Icons.arrow_back_ios_new, size: 13.r),
                        label: Text('Back'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xff64748B),
                          side: BorderSide(color: Color(0xffE2E8F0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Builder(
                        builder: (ctx) => IconButton(
                          icon: const Icon(Icons.refresh, color: Color(0xff64748B)),
                          tooltip: 'Refresh',
                          onPressed: () => ctx.read<PendingApprovalsCubit>().getPendingApprovals(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'Pending Approvals',
                    style: TextStyle(
                      color: Color(0xff111827),
                      fontSize: 27.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Review and approve provider registrations',
                    style: TextStyle(
                      color: Color(0xff2F93E6),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<PendingApprovalsCubit,
                  PendingApprovalsState>(
                builder: (context, state) {
                  if (state.status ==
                      PendingApprovalsStatus.loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(12.r),
                    itemCount: state.providers.length,
                    itemBuilder: (context, index) {
                      final provider = state.providers[index];

                      return PendingApprovalCard(
                        provider: provider,

                        // هنا التعديل
                        onViewDocuments: () {
                          final cubit =
                              context.read<PendingApprovalsCubit>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PendingDocumentsScreen(
                                provider: provider,
                                cubit: cubit,
                              ),
                            ),
                          );
                        },

                        onApprove: () {
                          context
                              .read<PendingApprovalsCubit>()
                              .approveProvider(provider['id']);
                        },

                        onReject: () {
                          context
                              .read<PendingApprovalsCubit>()
                              .rejectProvider(provider['id']);
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