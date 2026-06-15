import 'package:ehtemam_final_project/features/payment/manager/payment_cubit.dart';
import 'package:ehtemam_final_project/features/payment/manager/payment_state.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/balance_card.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/cost_breakdown.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/income_expense_row.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/transaction_history.dart';
import 'package:flutter/material.dart';
import 'package:ehtemam_final_project/core/resources/custom_snack_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Called when the app comes back to the foreground (e.g. after browser payment).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<PaymentCubit>().loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            if (state is PaymentLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PaymentError) {
              return Center(child: Text(state.message));
            }

            if (state is PaymentLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<PaymentCubit>().loadData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "My Wallet",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () =>
                                  context.read<PaymentCubit>().loadData(),
                              icon: const Icon(Icons.refresh),
                              tooltip: 'Refresh',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        BalanceCard(balance: state.balance),
                        const SizedBox(height: 16),
                        IncomeExpenseRow(
                          income: state.income,
                          expense: state.expense,
                        ),
                        const SizedBox(height: 20),
                        CostBreakdown(
                          serviceCost: state.serviceCost,
                          platformFee: state.platformFee,
                          taxRate: state.taxRate,
                          total: state.total,
                          onPay: () async {
                            final error =
                                await context.read<PaymentCubit>().payBooking();
                            if (!context.mounted) return;
                            if (error != null) {
                              CustomSnackBar.show(context, message: error);
                            } else {
                              CustomSnackBar.show(
                                context,
                                message: 'Payment completed successfully',
                              );
                              Navigator.of(context).pop(true);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TransactionHistory(transactions: state.transactions),
                      ],
                    ),
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
