import 'package:ehtemam_final_project/features/account_settings/ui/screens/change_password_screen.dart';
import 'package:ehtemam_final_project/features/account_settings/ui/widgets/language_card.dart';
import 'package:ehtemam_final_project/features/account_settings/ui/widgets/settings_title.dart';
import 'package:ehtemam_final_project/features/bottom_nav_bar/manager/bottom_nav_bar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/manager/auth_cubit.dart';
import '../../../auth/ui/screens/login_screen.dart';
import '../../manager/account_settings_cubit.dart';
import '../../manager/account_settings_state.dart';
import 'package:easy_localization/easy_localization.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AccountSettingsCubit>().loadUserData();
  }

  Widget sectionTitle(String title, {Color color = const Color(0xFF475467)}) {
    return Padding(
      padding: EdgeInsets.only(top: 18.h, bottom: 8.h, left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text('delete_account'.tr(),
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            color: Colors.red,
          ),
        ),
        content: Text('confirm_delete_account'.tr(),
          style: TextStyle(fontFamily: 'Inter', fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('delete'.tr(),
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    final error = await context.read<AccountSettingsCubit>().deleteAccount();

    if (!context.mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    } else {
      // Reset in-memory auth state so no stale token/user data lingers.
      await context.read<AuthCubit>().logout();
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 18.r,
          offset: Offset(0, 6),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountSettingsCubit, AccountSettingsState>(
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message!)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F8FC),
          body: SafeArea(
            child: state.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    padding: EdgeInsets.fromLTRB(18, 16, 18, 24),
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                context.read<BottomNavCubit>().changeTab(3);
                              }
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              size: 22.r,
                              color: Color(0xFF1D2939),
                            ),
                          ),
                          Text('account_settings'.tr(),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D2939),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Color(0xFF1D2939)),
                            tooltip: 'refresh'.tr(),
                            onPressed: () => context.read<AccountSettingsCubit>().loadUserData(),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // ── Profile Card ──
                      Container(
                        height: 90.h,
                        padding: EdgeInsets.all(16.r),
                        decoration: cardDecoration(),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: state.profileImageUrl.isNotEmpty
                                  ? () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => FullScreenImagePage(
                                              imageUrl: state.profileImageUrl),
                                        ),
                                      )
                                  : null,
                              child: CircleAvatar(
                                radius: 31,
                                backgroundColor: const Color(0xFF8EC5FF),
                                backgroundImage: state.profileImageUrl.isNotEmpty
                                    ? NetworkImage(state.profileImageUrl)
                                    : null,
                                onBackgroundImageError: state.profileImageUrl.isNotEmpty
                                    ? (_, _) {}
                                    : null,
                                child: state.profileImageUrl.isEmpty
                                    ? Icon(
                                        Icons.person_outline_rounded,
                                        color: Colors.white,
                                        size: 34.r,
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.name.isEmpty
                                        ? 'User Name'
                                        : state.name,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1D2939),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    state.email.isEmpty
                                        ? 'user@email.com'
                                        : state.email,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF667085),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      sectionTitle('PERSONAL INFORMATION'),

                      SettingsTile(
                        icon: Icons.person_outline_rounded,
                        title: 'Full Name',
                        subtitle:
                            state.name.isEmpty ? 'No name added' : state.name,
                      ),
                      SettingsTile(
                        icon: Icons.mail_outline_rounded,
                        title: 'Email Address',
                        subtitle: state.email.isEmpty
                            ? 'No email added'
                            : state.email,
                      ),
                      SettingsTile(
                        icon: Icons.phone_outlined,
                        title: 'Phone Number',
                        subtitle: state.phone.isEmpty
                            ? 'No phone added'
                            : state.phone,
                      ),
                      SettingsTile(
                        icon: Icons.location_on_outlined,
                        title: 'Address',
                        subtitle: state.government.isEmpty
                            ? 'No address added'
                            : state.government,
                        iconColor: const Color(0xFF12B76A),
                        iconBgColor: const Color(0xFFD1FADF),
                      ),

                      sectionTitle('SECURITY'),

                      SettingsTile(
                        icon: Icons.lock_outline_rounded,
                        title: 'Change Password',
                        subtitle: 'Update your password',
                        iconColor: const Color(0xFFFF3B30),
                        iconBgColor: const Color(0xFFFFE8E8),
                        showArrow: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChangePasswordScreen(),
                            ),
                          );
                        },
                      ),

                      sectionTitle('PREFERENCES'),

                      const LanguageCard(),

                      sectionTitle('DANGER ZONE', color: Colors.red),

                      SettingsTile(
                        icon: Icons.delete_outline_rounded,
                        title: 'Delete Account',
                        subtitle: 'Permanently delete your account',
                        iconColor: Colors.red,
                        iconBgColor: const Color(0xFFFFE8E8),
                        titleColor: Colors.red,
                        showArrow: true,
                        onTap: () => _showDeleteDialog(context),
                      ),

                      SizedBox(height: 10.h),

                      // ── Logout Button ──
                      Container(
                        height: 50.h,
                        decoration: cardDecoration(),
                        child: TextButton.icon(
                          onPressed: () async {
                            await context.read<AuthCubit>().logout();
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          icon: Icon(
                            Icons.logout_rounded,
                            color: Colors.red,
                            size: 18.r,
                          ),
                          label: Text('logout'.tr(),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}