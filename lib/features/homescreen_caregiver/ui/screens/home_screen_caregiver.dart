import 'package:ehtemam_final_project/features/bottom_nav_bar/manager/bottom_nav_bar_cubit.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/widgets/language_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HcHomeScreen extends StatefulWidget {
  const HcHomeScreen({super.key});

  @override
  State<HcHomeScreen> createState() => _HcHomeScreenState();
}

class _HcHomeScreenState extends State<HcHomeScreen> {
  String _userName = 'Caregiver';
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName');
    if (!mounted || name == null || name.isEmpty) return;

    setState(() => _userName = name);
  }

  void _openTab(int index) {
    context.read<BottomNavCubit>().changeTab(index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final s = (width / 390).clamp(0.85, 1.15);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(16 * s, 12 * s, 16 * s, 100 * s),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14 * s,
                          color: const Color(0xFF667085),
                        ),
                      ),
                      SizedBox(height: 4 * s),
                      Text(
                        _userName,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 24 * s,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF222222),
                        ),
                      ),
                    ],
                  ),
                ),
                const LanguageSwitcher(),
              ],
            ),
            SizedBox(height: 20 * s),
            _AvailabilityCard(
              scale: s,
              isAvailable: _isAvailable,
              onChanged: (value) => setState(() => _isAvailable = value),
            ),
            SizedBox(height: 16 * s),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    scale: s,
                    label: 'Pending',
                    value: '0',
                    color: const Color(0xFFFFC857),
                    onTap: () => _openTab(1),
                  ),
                ),
                SizedBox(width: 10 * s),
                Expanded(
                  child: _StatCard(
                    scale: s,
                    label: 'Active',
                    value: '0',
                    color: const Color(0xFF4A90E2),
                    onTap: () => _openTab(1),
                  ),
                ),
                SizedBox(width: 10 * s),
                Expanded(
                  child: _StatCard(
                    scale: s,
                    label: 'Earnings',
                    value: '0',
                    color: const Color(0xFF4CAF50),
                    onTap: () => _openTab(2),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24 * s),
            Text(
              'Quick actions',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16 * s,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF222222),
              ),
            ),
            SizedBox(height: 12 * s),
            _QuickActionTile(
              scale: s,
              icon: Icons.work_outline_rounded,
              title: 'View care requests',
              subtitle: 'Review and respond to new requests',
              onTap: () => _openTab(1),
            ),
            SizedBox(height: 10 * s),
            _QuickActionTile(
              scale: s,
              icon: Icons.attach_money_rounded,
              title: 'Check earnings',
              subtitle: 'Track your income and transactions',
              onTap: () => _openTab(2),
            ),
            SizedBox(height: 10 * s),
            _QuickActionTile(
              scale: s,
              icon: Icons.person_outline_rounded,
              title: 'Manage profile',
              subtitle: 'Update account and preferences',
              onTap: () => _openTab(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  final double scale;
  final bool isAvailable;
  final ValueChanged<bool> onChanged;

  const _AvailabilityCard({
    required this.scale,
    required this.isAvailable,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44 * scale,
            height: 44 * scale,
            decoration: BoxDecoration(
              color: isAvailable
                  ? const Color(0xFFEAF4FF)
                  : const Color(0xFFF2F4F7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAvailable ? Icons.check_circle_rounded : Icons.pause_circle_rounded,
              color: const Color(0xFF3A8BD7),
              size: 24 * scale,
            ),
          ),
          SizedBox(width: 12 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Availability',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15 * scale,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF222222),
                  ),
                ),
                SizedBox(height: 2 * scale),
                Text(
                  isAvailable ? 'You are available for new requests' : 'You are currently unavailable',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12 * scale,
                    color: const Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isAvailable,
            activeTrackColor: const Color(0xFF3A8BD7),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final double scale;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({
    required this.scale,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14 * scale),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14 * scale),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12 * scale,
            vertical: 16 * scale,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14 * scale),
            border: Border.all(color: const Color(0xFFE4E7EC)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8 * scale,
                height: 8 * scale,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: 10 * scale),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22 * scale,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF222222),
                ),
              ),
              SizedBox(height: 2 * scale),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12 * scale,
                  color: const Color(0xFF667085),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final double scale;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.scale,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14 * scale),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14 * scale),
        child: Padding(
          padding: EdgeInsets.all(14 * scale),
          child: Row(
            children: [
              Container(
                width: 42 * scale,
                height: 42 * scale,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(12 * scale),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF3A8BD7),
                  size: 22 * scale,
                ),
              ),
              SizedBox(width: 12 * scale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14 * scale,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF222222),
                      ),
                    ),
                    SizedBox(height: 2 * scale),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12 * scale,
                        color: const Color(0xFF667085),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: const Color(0xFF98A2B3),
                size: 22 * scale,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
