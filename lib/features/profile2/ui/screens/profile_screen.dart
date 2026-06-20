import 'package:ehtemam_final_project/features/auth/manager/auth_cubit.dart';
import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:ehtemam_final_project/features/notifications/ui/screens/notification_screen.dart';
import 'package:ehtemam_final_project/features/account_settings/data/repo/account_settings_repo.dart';
import 'package:ehtemam_final_project/features/account_settings/manager/account_settings_cubit.dart';
import 'package:ehtemam_final_project/features/account_settings/ui/screens/account_settings_screen_user.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/login_screen.dart';
import 'package:ehtemam_final_project/features/profile2/data/repo/profile_repo.dart';
import 'package:ehtemam_final_project/features/profile2/manager/profile_cubit.dart';
import 'package:ehtemam_final_project/features/profile2/manager/profile_state.dart';
import 'package:ehtemam_final_project/features/profile2/ui/widgets/logout_button.dart';
import 'package:ehtemam_final_project/features/profile2/ui/widgets/option_item.dart';
import 'package:ehtemam_final_project/features/profile2/ui/widgets/profile_card.dart';
import 'package:ehtemam_final_project/features/profile2/ui/widgets/profile_header.dart';
import 'package:ehtemam_final_project/features/profile2/ui/widgets/stats_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ehtemam_final_project/features/payment/data/repo/payment_repo.dart';
import 'package:ehtemam_final_project/features/payment/manager/payment_cubit.dart';
import 'package:ehtemam_final_project/features/payment/ui/screens/payment_screen.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<AuthCubit>().state.isGuest) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Text(
                'Please login to view your profile.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => ProfileCubit(ProfileRepo())..loadProfile(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
               if (state is ProfileLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is ProfileError) {
                final isAuthError = state.message.contains('User ID not found') ||
                    state.message.contains('not logged in') ||
                    state.message.contains('401');
                if (isAuthError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.r),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock_outline, size: 64.r, color: Color(0xFF6C63FF)),
                          SizedBox(height: 16.h),
                          Text(
                            'Session Expired',
                            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Please log in again to view your profile.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 24.h),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.clear();
                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  (_) => false,
                                );
                              }
                            },
                            child: Text('Log In'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Center(child: Text(state.message));
              }
              if (state is! ProfileLoaded) {
                return Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfileHeader(),
                    SizedBox(height: 16.h),
                    ProfileCard(user: state.user),
                    SizedBox(height: 16.h),
                    StatsRow(
                      totalRequests:     state.totalRequests,
                      rating:            state.rating,
                      totalReviewsCount: state.totalReviewsCount,
                    ),
                     SizedBox(height: 16.h),
                    _OptionsCard(),
                     SizedBox(height: 16.h),
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
            create: (_) => AccountSettingsCubit(AccountSettingsRepo(ApiService())),
            child: const AccountSettingsScreen(),
          ),
        ),);
  },),
    _OptionData(icon: Icons.notifications_outlined, label: "notifications", color: const Color.fromARGB(255, 245, 221, 126),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NotificationScreen()),
      );
    },),
   
    _OptionData(icon: Icons.account_balance_wallet_outlined, label: "My Wallet", color: const Color.fromARGB(255, 126, 186, 243),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<PaymentCubit>(),
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
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4.r),
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6.r),
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
              if (!isLast) Divider(height: 1.h, indent: 16, endIndent: 16),
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