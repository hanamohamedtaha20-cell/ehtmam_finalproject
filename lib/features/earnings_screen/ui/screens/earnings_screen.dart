import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/earnings_screen/data/repo/earnings_repo.dart';
import 'package:ehtemam_final_project/features/earnings_screen/manager/earnings_cubit.dart';
import 'package:ehtemam_final_project/features/earnings_screen/manager/state/earning_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/earnings_header_card.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/stats_card.dart';
import 'package:easy_localization/easy_localization.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          EarningsCubit(EarningsRepository(ApiService()))..getEarnings(),
      child: const EarningsView(),
    );
  }
}

class EarningsView extends StatelessWidget {
  const EarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('earnings'.tr(),
          style: TextStyle(
            color: Color(0xFF2B2D42),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<EarningsCubit, EarningsState>(
        builder: (context, state) {
          if (state is EarningsLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is EarningsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<EarningsCubit>().getEarnings(),
                    child: Text('retry'.tr()),
                  ),
                ],
              ),
            );
          }

          if (state is! EarningsLoaded) {
            return SizedBox.shrink();
          }

          final earnings = state.earnings;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                EarningsHeaderCard(
                  totalEarnings: earnings.totalEarnings,
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        value: earnings.jobs.toString(),
                        title: "Jobs",
                        color: const Color(0xFF4A90E2),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: StatsCard(
                        value: earnings.avgJob.toString(),
                        title: "Avg Job",
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: StatsCard(
                        value: '${earnings.hoursWorked}h',
                        title: "Hours",
                        color: const Color(0xFFFF9800),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                RecentTransactionsSection(
                  transactions: state.transactions,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
