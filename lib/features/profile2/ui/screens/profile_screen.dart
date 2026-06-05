import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/profile2/data/repo/profile_repo.dart';
import 'package:ehtemam_final_project/features/profile2/manager/profile_cubit.dart';
import 'package:ehtemam_final_project/features/profile2/manager/profile_state.dart';
import 'package:ehtemam_final_project/features/profile2/ui/widgets/logout_button.dart';
import 'package:ehtemam_final_project/features/profile2/ui/widgets/option_item.dart';
import 'package:ehtemam_final_project/features/profile2/ui/widgets/profile_card.dart';
import 'package:ehtemam_final_project/features/profile2/ui/widgets/profile_header.dart';
import 'package:ehtemam_final_project/features/profile2/ui/widgets/stats_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(ProfileRepo())..loadProfile(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is! ProfileLoaded) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfileHeader(),
                    const SizedBox(height: 16),
                    ProfileCard(user: state.user),
                    const SizedBox(height: 16),
                    StatsRow(
                      totalRequests: state.totalRequests,
                      completed: state.completed,
                      rating: state.rating,
                    ),
                    const SizedBox(height: 16),
                    _OptionsCard(),
                    const SizedBox(height: 16),
                    const LogoutButton(),
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

class _OptionsCard extends StatelessWidget {
  final List<_OptionData> _options = const [
    _OptionData(icon: Icons.settings_outlined, label: "accountSettings", color: Color(0xFF45556C)),
    _OptionData(icon: Icons.notifications_outlined, label: "notifications", color: Color(0xFFFEF3C6)),
    _OptionData(icon: Icons.location_on_outlined, label: "savedAddresses", color: Color(0xFFFF7E22)),
    _OptionData(icon: Icons.account_balance_wallet_outlined, label: "My Wallet", color: Color(0xFF97CCFD)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4),
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6),
        ],
      ),
      child: Column(
        children: List.generate(_options.length, (i) {
          final isLast = i == _options.length - 1;
          return Column(
            children: [
              OptionItem(
                icon: _options[i].icon,
                label: _options[i].label,
                color: _options[i].color,
                isGradient: _options[i].label == "accountSettings",
              ),
              if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }),
      ),
    );
  }
}

class _OptionData {
  final IconData icon;
  final String label;
  final Color color;

  const _OptionData({required this.icon, required this.label, required this.color});
}