import 'package:ehtemam_final_project/features/admin_features/manager/transactions/transactions_cubit.dart';
import 'package:ehtemam_final_project/features/admin_features/manager/transactions/transactions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/transactions_card.dart';

class ViewTransactionsScreen extends StatelessWidget {
  const ViewTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>  TransactionsCubit()
        ..getTransactions(),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              child: Column(
                  children: [
                    Container(
                      height: 72.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      color: Colors.white,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              size: 18.r,
                              color: Color(0xff1F2937),
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'View Transactions',
                                  style: TextStyle(
                                    color: Color(0xff111827),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  'Monitor all platform\ntransactions',
                                  style: TextStyle(
                                    color: Color(0xff6B7280),
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Builder(
                            builder: (ctx) => IconButton(
                              icon: const Icon(Icons.refresh, color: Color(0xff1F2937)),
                              tooltip: 'Refresh',
                              onPressed: () => ctx.read<TransactionsCubit>().getTransactions(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: BlocBuilder<
                          TransactionsCubit,
                          TransactionsState>(
                        builder: (context, state) {
                          if (state.status ==
                              TransactionsStatus.loading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state.status ==
                              TransactionsStatus.error) {
                            return Center(
                              child: Text(
                                state.errorMessage,
                              ),
                            );
                          }

                          if (state.transactions.isEmpty) {
                            return Center(
                              child: Text(
                                'No transactions found',
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.fromLTRB(
                              16,
                              18,
                              16,
                              18,
                            ),
                            itemCount:
                            state.transactions.length,
                            itemBuilder: (context, index) {
                              return TransactionCard(
                                transaction:
                                state.transactions[index],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ]
              )
          )
      ),
    );
  }
}