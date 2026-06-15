import 'package:ehtemam_final_project/features/account_settings/ui/screens/change_password_screen.dart';
import 'package:ehtemam_final_project/features/account_settings/ui/widgets/settings_title.dart';
import 'package:ehtemam_final_project/features/bottom_nav_bar/manager/bottom_nav_bar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/manager/auth_cubit.dart';
import '../../../auth/ui/screens/login_screen.dart';
import '../../manager/account_settings_cubit.dart';
import '../../manager/account_settings_state.dart';

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
                          Text(
                            'Account Settings',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D2939),
                            ),
                          ),
                          Spacer(),
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
                            CircleAvatar(
                              radius: 31,
                              backgroundColor: Color(0xFF8EC5FF),
                              child: Icon(
                                Icons.person_outline_rounded,
                                color: Colors.white,
                                size: 34.r,
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

                      sectionTitle('NOTIFICATIONS'),

                      // ── Fix: Material wrapper around SwitchListTile ──
                      Container(
                        height: 66.h,
                        decoration: cardDecoration(),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.r),
                          child: SwitchListTile(
                            value: state.notifications,
                            activeColor: const Color(0xFF4EA3F1),
                            onChanged: (value) {
                              context
                                  .read<AccountSettingsCubit>()
                                  .toggleNotifications(value);
                            },
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 14.w),
                            secondary: CircleAvatar(
                              radius: 20,
                              backgroundColor: Color(0xFFFFF0C2),
                              child: Icon(
                                Icons.notifications_none_rounded,
                                color: Colors.orange,
                                size: 22.r,
                              ),
                            ),
                            title: Text(
                              'Push Notifications',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D2939),
                              ),
                            ),
                            subtitle: Text(
                              'Receive app notifications',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10.5.sp,
                                color: Color(0xFF98A2B3),
                              ),
                            ),
                          ),
                        ),
                      ),


                      sectionTitle('DANGER ZONE', color: Colors.red),

                      const SettingsTile(
                        icon: Icons.delete_outline_rounded,
                        title: 'Delete Account',
                        subtitle: 'Permanently delete your account',
                        iconColor: Colors.red,
                        iconBgColor: Color(0xFFFFE8E8),
                        titleColor: Colors.red,
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
                          label: Text(
                            'Logout',
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