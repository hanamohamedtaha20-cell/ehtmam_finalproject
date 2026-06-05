import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/widgets/language_switcher.dart';
import 'package:ehtemam_final_project/features/payment/data/model/payment_model.dart';
import 'package:ehtemam_final_project/features/payment/manager/payment_cubit.dart';
import 'package:ehtemam_final_project/features/payment/manager/payment_state.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/balance_card.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/cost_breakdown.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/income_expense_row.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/pay_button.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/transaction_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            if (state is PaymentLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "My Wallet",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                           Spacer(), 
                           LanguageSwitcher(),
                        ],
                    
                      ),
                
                      const SizedBox(height: 20),
                
                      /// BALANCE
                      BalanceCard(balance: state.balance),
                
                      const SizedBox(height: 16),
                
                      /// INCOME EXPENSE
                      IncomeExpenseRow(
                        income: state.income,
                        expense: state.expense,
                      ),
                
                      const SizedBox(height: 20),
                
                      /// COST BREAKDOWN
                
                      CostBreakdown(
                        serviceCost: 560.00,
                        platformFee: 150.00,
                        taxRate: 100.00,
                        total: 1000.00,
                      ),
                      /// BUTTON
                
                      const SizedBox(height: 20),
            
                      TransactionHistory(
                      transactions: [
                        TransactionModel(
                          title: "Wallet Top-up via Vodafone Cash",
                          amount: 200.00,
                          date: DateTime(2026, 4, 14),
                          status: "Completed",
                          isIncome: true,
                        ),
                        TransactionModel(
                          title: "Payment for Pet Care Service",
                          amount: 402.50,
                          date: DateTime(2026, 4, 12),
                          status: "Completed",
                          isIncome: false,
                        ),
                      ],
                    )
                    ],
                  ),
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}