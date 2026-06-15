import 'package:ehtemam_final_project/features/payment/ui/widgets/balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/cg_payment_repo.dart';
import '../../manager/cg_payment_cubit.dart';
import '../../manager/cg_payment_state.dart';
import '../widgets/cg_earnings_header.dart';
import '../widgets/cg_filter_tabs.dart';
import '../widgets/cg_transaction_item.dart';

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Payments Received',
            style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 18.sp, color: Colors.black)),
      ),
      body: BlocBuilder<CgPaymentCubit, CgPaymentState>(
        builder: (context, state) {
          if (state is CgPaymentLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is CgPaymentError) {
            return Center(child: Text(state.message));
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