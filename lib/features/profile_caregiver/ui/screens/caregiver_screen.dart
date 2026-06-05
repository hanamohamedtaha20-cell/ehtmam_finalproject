import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/data/repo/caregiver_repo.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/manager/caregiver_cubit.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/manager/caregiver_state.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/ui/widgets/caregiver_profile_card.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/ui/widgets/contact_info_card.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/ui/widgets/logout_row.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/ui/widgets/menu_options_card.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/ui/widgets/performance_card.dart';
import 'package:ehtemam_final_project/features/profile_caregiver/ui/widgets/screen_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaregiverScreen extends StatelessWidget {
  const CaregiverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CaregiverCubit(CaregiverRepo())..loadProfile(),
      child: Scaffold(
        backgroundColor:  Colors.white,
        body: SafeArea(
          child: BlocBuilder<CaregiverCubit, CaregiverState>(
            builder: (context, state) {
              if (state is! CaregiverLoaded) {
                return  Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                padding:  EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfileHeader(),
                    const SizedBox(height: 16),
                    CaregiverProfileCard(profile: state.profile),
                    const SizedBox(height: 16),
                    ContactInfoCard(profile: state.profile),
                    const SizedBox(height: 16),
                    PerformanceCard(profile: state.profile),
                    const SizedBox(height: 16),
                    const MenuOptionsCard(),
                    const SizedBox(height: 16),
                    const LogoutRow(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}