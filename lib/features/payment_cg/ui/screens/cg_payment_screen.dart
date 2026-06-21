import 'package:ehtemam_final_project/features/payment/ui/widgets/balance_card_user.dart';
import 'package:ehtemam_final_project/features/payment_cg/ui/widgets/balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/cg_payment_repo.dart';
import '../../manager/cg_payment_cubit.dart';
import '../../manager/cg_payment_state.dart';
import '../widgets/cg_earnings_header.dart';
import '../widgets/cg_filter_tabs.dart';
import '../widgets/cg_transaction_item.dart';
import 'package:easy_localization/easy_localization.dart';

class CgPaymentScreen extends StatelessWidget {
  const CgPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CgPaymentCubit(CgPaymentRepo())..loadData(),
      child: const _CgPaymentView(),
    );
  }
}

class _CgPaymentView extends StatelessWidget {
  const _CgPaymentView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
       
        title: Text('payments_received'.tr(),
          style: TextStyle(
            fontFamily: "Arimo",
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: Colors.black,
          ),
        ),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              tooltip: 'refresh'.tr(),
              onPressed: () => ctx.read<CgPaymentCubit>().loadData(),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CgPaymentCubit, CgPaymentState>(
        builder: (context, state) {
          if (state is CgPaymentLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is CgPaymentError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48.r,
                      color: Colors.red.shade300,
                    ),
                    SizedBox(height: 12.h),
                    Text('could_not_load_payment'.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text('check_connection_retry'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<CgPaymentCubit>().loadData(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text('retry'.tr()),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is CgPaymentLoaded) {
            final cubit = context.read<CgPaymentCubit>();
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      BalanceCard(balance: state.balance),

                      SizedBox(height: 16.h),
                      CgEarningsHeader(
                        totalEarned: state.totalEarned,
                        pending: state.pending,
                      ),
                      SizedBox(height: 16.h),
                      CgFilterTabs(
                        selected: state.filter,
                        onFilter: cubit.filterBy,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    children: state.filteredTransactions
                        .map((t) => CgTransactionItem(transaction: t))
                        .toList(),
                  ),
                ),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
