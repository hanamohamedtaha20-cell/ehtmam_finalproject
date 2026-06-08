import 'package:ehtemam_final_project/features/account_settings/manager/account_settings_cubit.dart';
import 'package:ehtemam_final_project/features/account_settings/ui/screens/account_settings_screen_user.dart';
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
import 'package:ehtemam_final_project/features/payment/data/repo/payment_repo.dart';
import 'package:ehtemam_final_project/features/payment/manager/payment_cubit.dart';
import 'package:ehtemam_final_project/features/payment/ui/screens/payment_screen.dart';
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
               if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ProfileError) {
                return Center(child: Text(state.message));
              }
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
                     SizedBox(height: 16),
                    _OptionsCard(),
                     SizedBox(height: 16),
                     LogoutButton(),
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
List<_OptionData> _buildOptions(BuildContext context) => [
    _OptionData(icon: Icons.settings_outlined, label: "accountSettings", color: const Color(0xFF45556C),
    onTap: () {Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AccountSettingsCubit(),
            child: const AccountSettingsScreen(),
          ),
        ),);
  },),
    _OptionData(icon: Icons.notifications_outlined, label: "notifications", color: const Color.fromARGB(255, 245, 221, 126),
    onTap: () {
      // Navigator.push(context, ...)
    },),
    _OptionData(icon: Icons.location_on_outlined, label: "savedAddresses", color: const Color.fromARGB(255, 168, 241, 194),
    onTap: () {
      // Navigator.push(context, ...)
    },),
    _OptionData(icon: Icons.account_balance_wallet_outlined, label: "My Wallet", color: const Color.fromARGB(255, 126, 186, 243),
    onTap: () {
       Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => PaymentCubit(PaymentRepo()),
          child: const PaymentScreen(),
        ),
      ),
    );  
    },),
  ];

  @override
  Widget build(BuildContext context) {
    final List<_OptionData> options = _buildOptions(context); 
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
        children: List.generate(options.length, (i) {
          final isLast = i == options.length - 1;
          return Column(
            children: [
              OptionItem(
                icon:options[i].icon,
                label: options[i].label,
                color: options[i].color,
                onTap: options[i].onTap,

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
  final VoidCallback? onTap;


  const _OptionData({required this.icon, required this.label, required this.color, this.onTap});
}