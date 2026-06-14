import 'package:ehtemam_final_project/features/admin_features/manager/transactions/transactions_cubit.dart';
import 'package:ehtemam_final_project/features/admin_features/manager/transactions/transactions_state.dart';
import 'package:flutter/material.dart';
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
                      height: 72,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.white,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: Color(0xff1F2937),
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'View Transactions',
                                  style: TextStyle(
                                    color: Color(0xff111827),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Monitor all platform\ntransactions',
                                  style: TextStyle(
                                    color: Color(0xff6B7280),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 26,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xffF3F7FB),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.language,
                                    size: 14, color: Color(0xff64748B)),
                                SizedBox(width: 4),
                                Text(
                                  'ع',
                                  style: TextStyle(
                                    color: Color(0xff64748B),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
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
                            return const Center(
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
                            return const Center(
                              child: Text(
                                'No transactions found',
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
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