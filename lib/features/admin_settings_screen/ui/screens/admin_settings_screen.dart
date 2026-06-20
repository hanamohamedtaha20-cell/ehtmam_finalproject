import 'package:ehtemam_final_project/features/account_settings/ui/widgets/settings_title.dart';
import 'package:ehtemam_final_project/features/auth/manager/auth_cubit.dart';
import 'package:ehtemam_final_project/features/auth/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  String _name  = '';
  String _email = '';
  String _phone = '';
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _name  = prefs.getString('user_name')  ?? 'Admin User';
      _email = prefs.getString('user_email') ?? '';
      _phone = prefs.getString('user_phone') ?? '';
    });
  }

  BoxDecoration _card() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18.r,
            offset: const Offset(0, 6),
          ),
        ],
      );

  Widget _sectionTitle(String text, {Color color = const Color(0xFF475467)}) =>
      Padding(
        padding: EdgeInsets.only(top: 18.h, bottom: 8.h, left: 4.w),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.2,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(18, 20, 18, 32),
          children: [
            // ── Title ──
            Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1D2939),
              ),
            ),

            SizedBox(height: 20.h),

            // ── Profile card ──
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: _card(),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 31,
                    backgroundColor: const Color(0xFF8EC5FF),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: Colors.white,
                      size: 34.r,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name.isEmpty ? 'Admin User' : _name,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1D2939),
                          ),
                        ),
                        if (_email.isNotEmpty) ...[
                          SizedBox(height: 3.h),
                          Text(
                            _email,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.sp,
                              color: const Color(0xFF667085),
                            ),
                          ),
                        ],
                        SizedBox(height: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A8BD7),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            'Super Admin',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Personal information ──
            _sectionTitle('PERSONAL INFORMATION'),

            SettingsTile(
              icon: Icons.person_outline_rounded,
              title: 'Full Name',
              subtitle: "judy"
            ),
            SettingsTile(
              icon: Icons.mail_outline_rounded,
              title: 'Email Address',
              subtitle: _email.isEmpty ? 'No email added' : _email,
            ),
           
            SettingsTile(
              icon: Icons.location_on_outlined,
              title: 'Address',
              subtitle: 'Cairo, Egypt\nstreet:El Geish Street\nbuilding:15 ',
              iconColor: const Color(0xFF12B76A),
              iconBgColor: const Color(0xFFD1FADF),
            ),

           

            SizedBox(height: 16.h),

            // ── Logout ──
            Container(
              height: 50.h,
              decoration: _card(),
              child: TextButton.icon(
                onPressed: () async {
                  await context.read<AuthCubit>().logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                icon: Icon(Icons.logout_rounded, color: Colors.red, size: 18.r),
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
  }
}
