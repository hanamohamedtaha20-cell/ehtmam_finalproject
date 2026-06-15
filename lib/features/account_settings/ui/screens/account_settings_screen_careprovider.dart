import 'package:ehtemam_final_project/features/account_settings/manager/account_settings_cubit.dart';
import 'package:ehtemam_final_project/features/account_settings/ui/screens/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/manager/auth_cubit.dart';
import '../../../auth/ui/screens/login_screen.dart';
import '../../manager/account_settings_cubit.dart';
import '../../manager/account_settings_state.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CareProviderAccountSettingsScreen extends StatefulWidget {
  const CareProviderAccountSettingsScreen({super.key});

  @override
  State<CareProviderAccountSettingsScreen> createState() =>
      _CareProviderAccountSettingsScreenState();
}

class _CareProviderAccountSettingsScreenState
    extends State<CareProviderAccountSettingsScreen> {

  @override
  void initState() {
    super.initState();
    context.read<AccountSettingsCubit>().loadUserData();
  }

  double scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (width / 390).clamp(0.85, 1.15);
  }

  Widget sectionTitle(
      BuildContext context,
      String title, {
        Color color = const Color(0xFF667085),
      }) {
    final s = scale(context);

    return Padding(
      padding: EdgeInsets.only(
        top: 14.h,
        bottom: 7.h,
        left: 2.w,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          color: color,
        ),
      ),
    );
  }

  Widget tile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color bg,
    bool arrow = false,
    Color titleColor = const Color(0xFF1D2939),
    VoidCallback? onTap,
  }) {
    final s = scale(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 11.h,
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 19.r, color: iconColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle.isEmpty ? 'Not added yet' : subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF667085),
                    ),
                  ),
                ],
              ),
            ),
            if (arrow)
              Icon(
                Icons.chevron_right_rounded,
                size: 20.r,
                color: const Color(0xFF98A2B3),
              ),
          ],
        ),
      ),
    );
  }

  Widget card(BuildContext context, List<Widget> children) {
    final s = scale(context);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14.r,
            offset: Offset(0, 5 * s),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget notificationTile(
      BuildContext context,
      AccountSettingsState state,
      ) {
    final s = scale(context);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 11.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14.r,
            offset: Offset(0, 5 * s),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8ED1FF),
                  Color(0xFF3A9DF8),
                ],
              ),
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Push Notifications',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1D2939),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'New request alerts',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.82 * s,
            child: Switch(
              value: state.notifications,
              onChanged: (value) {
                context
                    .read<AccountSettingsCubit>()
                    .toggleNotifications(value);
              },
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF4DAAF7),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFD0D5DD),
            ),
          ),
        ],
      ),
    );
  }

  Widget profileCard(
      BuildContext context,
      AccountSettingsState state,
      ) {
    final s = scale(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFEAF6FF),
          ],
        ),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 16.r,
            offset: Offset(0, 7 * s),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58.w,
            height: 58.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: state.profileImagePath.isNotEmpty
                      ? Image.file(
                    File(state.profileImagePath),
                    width: 58.w,
                    height: 58.h,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    width: 58.w,
                    height: 58.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF4DB1FF),
                          Color(0xFF1687E8),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person_outline_rounded,
                        color: Colors.white,
                        size: 29.r,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: -2 * s,
                  right: -2 * s,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      context.read<AccountSettingsCubit>().pickProfileImage();
                    },
                    child: Container(
                      width: 18.w,
                      height: 18.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4.r,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 10.r,
                          color: const Color(0xFF1687E8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.name.isEmpty ? 'Fatma Adel' : state.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1D2939),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  state.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF667085),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Certified Provider',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1687E8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = scale(context);

    return BlocBuilder<AccountSettingsCubit, AccountSettingsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 54.h,
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  color: Colors.white,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 17.r,
                          color: const Color(0xFF1D2939),
                        ),
                      ),
                      Text(
                        'Account Settings',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1D2939),
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.language_rounded,
                        size: 15.r,
                        color: const Color(0xFF667085),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'E',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF344054),
                        ),
                      ),
                      SizedBox(width: 14.w),
                    ],
                  ),
                ),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          18 * s,
                          12 * s,
                          18 * s,
                          18 * s,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              profileCard(context, state),

                              sectionTitle(context, 'PERSONAL INFORMATION'),

                              card(context, [
                                tile(
                                  context: context,
                                  icon: Icons.person_outline_rounded,
                                  title: 'Full Name',
                                  subtitle: state.name,
                                  iconColor: const Color(0xFF53A9F6),
                                  bg: const Color(0xFFEAF4FF),
                                ),
                                tile(
                                  context: context,
                                  icon: Icons.email_outlined,
                                  title: 'Email Address',
                                  subtitle: state.email,
                                  iconColor: const Color(0xFFB547F7),
                                  bg: const Color(0xFFF4EBFF),
                                ),
                                tile(
                                  context: context,
                                  icon: Icons.phone_outlined,
                                  title: 'Phone Number',
                                  subtitle: state.phone,
                                  iconColor: const Color(0xFF3B82F6),
                                  bg: const Color(0xFFEAF2FF),
                                ),
                                tile(
                                  context: context,
                                  icon: Icons.location_on_outlined,
                                  title: 'Service Area',
                                  subtitle: 'Elsheikh zayed, Giza',
                                  iconColor: const Color(0xFF22C55E),
                                  bg: const Color(0xFFE6F9F0),
                                ),
                              ]),

                              sectionTitle(
                                context,
                                'PROFESSIONAL INFORMATION',
                              ),

                              card(context, [
                                tile(
                                  context: context,
                                  icon: Icons.medical_services_outlined,
                                  title: 'Service Types',
                                  subtitle: 'Pet Care, Elderly Care',
                                  iconColor: const Color(0xFF22C55E),
                                  bg: const Color(0xFFE6F9F0),
                                ),
                                tile(
                                  context: context,
                                  icon: Icons.description_outlined,
                                  title: 'Documents & Certificates',
                                  subtitle: 'View uploaded documents',
                                  iconColor: const Color(0xFF6366F1),
                                  bg: const Color(0xFFEFF1FF),
                                ),
                                tile(
                                  context: context,
                                  icon: Icons.workspace_premium_outlined,
                                  title: 'Experience & Bio',
                                  subtitle: '5+ years experience',
                                  iconColor: const Color(0xFFF59E0B),
                                  bg: const Color(0xFFFFF6E5),
                                ),
                              ]),

                              sectionTitle(context, 'SECURITY'),

                              card(context, [
                                tile(
                                  context: context,
                                  icon: Icons.lock_outline_rounded,
                                  title: 'Change Password',
                                  subtitle: 'Update your password',
                                  iconColor: const Color(0xFFF04438),
                                  bg: const Color(0xFFFFE8E8),
                                  arrow: true,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                        const ChangePasswordScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ]),

                              sectionTitle(context, 'NOTIFICATIONS'),

                              notificationTile(context, state),

                              sectionTitle(context, 'PREFERENCES'),

                              card(context, [
                                tile(
                                  context: context,
                                  icon: Icons.language_rounded,
                                  title: 'Language',
                                  subtitle: 'English',
                                  iconColor: const Color(0xFF53A9F6),
                                  bg: const Color(0xFFEAF4FF),
                                  arrow: true,
                                ),
                              ]),

                              sectionTitle(
                                context,
                                'DANGER ZONE',
                                color: const Color(0xFFF04438),
                              ),

                              card(context, [
                                tile(
                                  context: context,
                                  icon: Icons.delete_outline_rounded,
                                  title: 'Delete Account',
                                  subtitle: 'Permanently delete your account',
                                  iconColor: const Color(0xFFF04438),
                                  bg: const Color(0xFFFFE8E8),
                                  titleColor: const Color(0xFFF04438),
                                  arrow: true,
                                ),
                              ]),

                              SizedBox(height: 2.h),

                              Container(
                                width: double.infinity,
                                height: 45.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFBFB),
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: const Color(0xFFFFCFCF),
                                  ),
                                ),
                                child: TextButton.icon(
                                  onPressed: () async {
                                    await context.read<AuthCubit>().logout();
                                    if (context.mounted) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => LoginScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.logout_rounded,
                                    color: const Color(0xFFF04438),
                                    size: 17.r,
                                  ),
                                  label: Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: const Color(0xFFF04438),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 28.h),

                              Center(
                                child: Text(
                                  'CareConnect Provider v1.0.0\n© 2024 All Rights Reserved',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 9.5.sp,
                                    height: 1.4.h,
                                    color: const Color(0xFF98A2B3),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      );
                    },
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