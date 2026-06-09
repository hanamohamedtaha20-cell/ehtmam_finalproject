import 'package:ehtemam_final_project/features/bottom_nav_bar/manager/bottom_nav_bar_cubit.dart';
import 'package:ehtemam_final_project/features/bottom_nav_bar/ui/caregiver_buttom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HcHomeScreen extends StatelessWidget {
  const HcHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavCubit(),
      child: const CareGiverBottomNavScreen(),
    );
  }
}
