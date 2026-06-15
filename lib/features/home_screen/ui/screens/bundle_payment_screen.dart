import 'package:ehtemam_final_project/core/resources/custom_snack_bar.dart';
import 'package:ehtemam_final_project/features/payment/data/repo/payment_repo.dart';
import 'package:ehtemam_final_project/features/payment/manager/payment_cubit.dart';
import 'package:ehtemam_final_project/features/payment/manager/payment_state.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/balance_card.dart';
import 'package:ehtemam_final_project/features/payment/ui/widgets/cost_breakdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BundlePaymentScreen extends StatelessWidget {
  final String bundleId;
  final String bundleName;
  final double bundlePrice;

  const BundlePaymentScreen({
    super.key,
    required this.bundleId,
    required this.bundleName,
    required this.bundlePrice,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentCubit(PaymentRepo())
        ..loadData(offerPrice: bundlePrice),
      child: _BundlePaymentBody(
        bundleId: bundleId,
        bundleName: bundleName,
      ),
    );
  }
}

class _BundlePaymentBody extends StatelessWidget {
  final String bundleId;
  final String bundleName;

  const _BundlePaymentBody({
    required this.bundleId,
    required this.bundleName,
  });

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
              return SingleChildScrollView(
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
                        SizedBox(width: 8.w),
                        Text(
                          bundleName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    BalanceCard(balance: state.balance),
                    SizedBox(height: 20.h),
                    CostBreakdown(
                      serviceCost: state.serviceCost,
                      platformFee: state.platformFee,
                      taxRate: state.taxRate,
                      total: state.total,
                      onPay: () async {
                        final error = await context
                            .read<PaymentCubit>()
                            .payBundlePurchase(bundleId);
                        if (!context.mounted) return;
                        if (error != null) {
                          CustomSnackBar.show(context, message: error);
                        } else {
                          CustomSnackBar.show(
                            context,
                            message: 'Bundle purchased successfully',
                          );
                          Navigator.of(context).pop(true);
                        }
                      },
                    ),
                  ],
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
