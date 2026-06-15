import 'package:ehtemam_final_project/features/account_settings/ui/screens/change_password_screen.dart';
import 'package:ehtemam_final_project/features/account_settings/ui/widgets/settings_title.dart';
import 'package:ehtemam_final_project/features/bottom_nav_bar/manager/bottom_nav_bar_cubit.dart';
import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.only(top: 18, bottom: 8, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
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
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 18,
          offset: const Offset(0, 6),
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
        return Container(
          color: const Color(0xFFF5F8FC),
          child: SafeArea(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
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
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 22,
                              color: Color(0xFF1D2939),
                            ),
                          ),
                          const Text(
                            'Account Settings',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D2939),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ── Profile Card ──
                      Container(
                        height: 90,
                        padding: const EdgeInsets.all(16),
                        decoration: cardDecoration(),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 31,
                              backgroundColor: Color(0xFF8EC5FF),
                              child: Icon(
                                Icons.person_outline_rounded,
                                color: Colors.white,
                                size: 34,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.name.isEmpty
                                        ? 'User Name'
                                        : state.name,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1D2939),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    state.email.isEmpty
                                        ? 'user@email.com'
                                        : state.email,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
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
                        height: 66,
                        decoration: cardDecoration(),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: SwitchListTile(
                            value: state.notifications,
                            activeColor: const Color(0xFF4EA3F1),
                            onChanged: (value) {
                              context
                                  .read<AccountSettingsCubit>()
                                  .toggleNotifications(value);
                            },
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 14),
                            secondary: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Color(0xFFFFF0C2),
                              child: Icon(
                                Icons.notifications_none_rounded,
                                color: Colors.orange,
                                size: 22,
                              ),
                            ),
                            title: const Text(
                              'Push Notifications',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D2939),
                              ),
                            ),
                            subtitle: const Text(
                              'Receive app notifications',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10.5,
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

                      const SizedBox(height: 10),

                      // ── Logout Button ──
                      Container(
                        height: 50,
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
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: Colors.red,
                            size: 18,
                          ),
                          label: const Text(
                            'Logout',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
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