import 'package:ehtemam_final_project/features/recharge_wallet/data/repo/recharge_repo.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/manager/recharge_cubit.dart';
import 'package:ehtemam_final_project/features/recharge_wallet/ui/screens/recharge_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AddFundsButton extends StatelessWidget {
  const AddFundsButton({super.key});

  @override
 Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => BlocProvider(
              create: (_) => RechargeCubit(RechargeRepo())..loadData(),
              child: const RechargeScreen(),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text(
              "+ Add Funds",
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