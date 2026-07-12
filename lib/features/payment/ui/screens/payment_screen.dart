import 'package:ehtemam_final_project/features/payment/manager/payment_cubit.dart';
import 'package:ehtemam_final_project/features/payment/manager/payment_state.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/balance_card_user.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/cost_breakdown.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/income_expense_row.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/transaction_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtemam_final_project/core/resources/custom_snack_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class PaymentScreen extends StatefulWidget {
  /// When set, this screen is used to pay for a caregiver-added extra task.
  /// The pay button will call [PaymentCubit.payExtraTask] instead of [PaymentCubit.payBooking].
  final String? taskId;
  final double? extraTaskPrice;

  /// The booking that owns this extra task. Sent to the payment endpoint
  /// so the backend can locate the task within the correct booking.
  final String? bookingId;

  /// When set (and taskId is null), the Pay button calls processPayment(offerId)
  /// to deduct the wallet and create the booking for a regular request.
  final String? offerId;

  const PaymentScreen({
    super.key,
    this.taskId,
    this.extraTaskPrice,
    this.bookingId,
    this.offerId,
  });

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

  // Reload when the app returns to foreground (e.g. after browser payment).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context
          .read<PaymentCubit>()
          .loadData(offerPrice: widget.extraTaskPrice);
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
                onRefresh: () => context
                    .read<PaymentCubit>()
                    .loadData(offerPrice: widget.extraTaskPrice),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              widget.taskId != null
                                  ? 'Pay Extra Task'
                                  : 'My Wallet',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => context
                                  .read<PaymentCubit>()
                                  .loadData(offerPrice: widget.extraTaskPrice),
                              icon: const Icon(Icons.refresh),
                              tooltip: 'refresh'.tr(),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        BalanceCarduser(balance: state.balance),
                        SizedBox(height: 16.h),
                        IncomeExpenseRow(
                          income: state.income,
                          expense: state.expense,
                        ),
                        SizedBox(height: 20.h),
                        CostBreakdown(
                          serviceCost: state.serviceCost,
                          platformFee: state.platformFee,
                          taxRate: state.taxRate,
                          total: state.total,
                          discountAmount: state.discountAmount,
                          bundleUsed: state.bundleUsed,
                          remainingSessions: state.remainingSessions,
                          onPay: () async {
                            final cubit = context.read<PaymentCubit>();
                            final String? error;
                            if (widget.taskId != null) {
                              error = await cubit.payExtraTask(
                                widget.taskId!,
                                bookingId: widget.bookingId,
                              );
                            } else {
                              error = await cubit.payBooking(widget.offerId ?? '');
                            }
                            if (!context.mounted) return;
                            if (error != null) {
                              CustomSnackBar.show(context, message: error);
                            } else {
                              CustomSnackBar.show(
                                context,
                                message: widget.taskId != null
                                    ? 'Additional task payment completed successfully'
                                    : 'Payment completed successfully',
                              );
                              Navigator.of(context).pop(true);
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
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
