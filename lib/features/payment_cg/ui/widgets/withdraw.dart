import 'package:ehtemam_final_project/features/payment/manager/payment_cubit.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/data/repo/recharge_repo.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/manager/recharge_cubit.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/ui/screens/recharge_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Withdraw extends StatelessWidget {
  const Withdraw({super.key});

  @override
 Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, 
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => BlocProvider.value(
            value: context.read<PaymentCubit>(),
            child: BlocProvider(
              create: (_) => RechargeCubit(RechargeRepo())..loadData(),
              child: const RechargeScreen(),
            ),
          ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Center(
            child: Text(
              "- Withdraw Funds",
              style: TextStyle(
                fontFamily: "Arimo",
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A8BD7),
              ),
            ),
          ),
        ),
      ),
    );
  }
}