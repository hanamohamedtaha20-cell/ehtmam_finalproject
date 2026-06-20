
import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/payment/manager/payment_cubit.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/manager/recharge_cubit.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/manager/recharge_state.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/ui/widgets/action_buttons.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/ui/widgets/custom_amount_field.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/ui/widgets/payment_methods_list.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/ui/widgets/quick_amounts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  int _selectedMethod = 0;
  double _selectedQuickAmount = 0;
  final TextEditingController _customAmountController =
  TextEditingController(text: "0.00");

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RechargeCubit, RechargeState>(
        listener: (context, state) {
          if (state is RechargeSuccess) {
            Navigator.pop(context);
            if (state.paymentUrl.isNotEmpty) {
              launchUrl(
                Uri.parse(state.paymentUrl),
                mode: LaunchMode.externalApplication,
              );
            }
          }
          if (state is RechargeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, AppColors.lightBlue, Colors.white],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4.r),
              BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6.r),
            ],
          ),
          padding: EdgeInsets.fromLTRB(
            16, 20, 16,
            24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    "Add Funds",
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp),
                  ),
                ),
                SizedBox(height: 20.h),
                Text("Select Payment Method",
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 13.sp,
                        color: AppColors.textLight)),
                SizedBox(height: 10.h),
                PaymentMethodsList(
                  selectedIndex: _selectedMethod,
                  onSelected: (i) => setState(() => _selectedMethod = i),
                ),
                SizedBox(height: 20.h),
                Text("Quick Amounts",
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 13.sp,
                        color: AppColors.textLight)),
                SizedBox(height: 10.h),
                QuickAmounts(
                  selectedAmount: _selectedQuickAmount,
                  onSelected: (amount) => setState(() {
                    _selectedQuickAmount = amount;
                    _customAmountController.text = amount.toStringAsFixed(2);
                  }),
                ),
                SizedBox(height: 20.h),
                Text("Custom Amount",
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 13.sp,
                        color: AppColors.textLight)),
                SizedBox(height: 8.h),
                CustomAmountField(controller: _customAmountController),
                SizedBox(height: 24.h),
                ActionButtons(
                  onConfirm: () {
                    final amount = double.tryParse(_customAmountController.text) ?? 0;
                    if (amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a valid amount')),
                      );
                      return;
                    }
                    context.read<RechargeCubit>().recharge(
                        amount: amount,
                        selectedMethodIndex: _selectedMethod,);
                  },
                ),          ],
            ),
          ),
        ));
  }
}//new