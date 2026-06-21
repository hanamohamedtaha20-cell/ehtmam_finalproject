import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/bottom_nav_bar/manager/bottom_nav_bar_cubit.dart';
import '../../manager/pending_approvals/pending_approvals_cubit.dart' show PendingApprovalsCubit;
import '../../manager/pending_approvals/pending_approvals_state.dart';
import '../widgets/pending_approval_card.dart';
import 'pending_documents_screen.dart';
import 'package:easy_localization/easy_localization.dart';

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
                        label: Text('back'.tr()),
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
                          tooltip: 'refresh'.tr(),
                          onPressed: () => ctx.read<PendingApprovalsCubit>().getPendingApprovals(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Text('pending_approvals'.tr(),
                    style: TextStyle(
                      color: Color(0xff111827),
                      fontSize: 27.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text('review_approve_providers'.tr(),
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

                        onViewDocuments: () async {
                          final approvalsCubit = context.read<PendingApprovalsCubit>();
                          final navCubit      = context.read<BottomNavCubit>();

                          final approved = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PendingDocumentsScreen(
                                provider: provider,
                                onApprove: () => approvalsCubit.approveProvider(provider['id']),
                                onReject:  () => approvalsCubit.rejectProvider(provider['id']),
                              ),
                            ),
                          );

                          if (approved == true && context.mounted) {
                            // Switch to Providers tab (index 2) and close the approvals screen
                            navCubit.changeTab(2);
                            Navigator.maybePop(context);
                          }
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