import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/account_settings/ui/screens/account_settings_screen_careprovider.dart';
import 'package:ehtemam_final_project/features/myTasks_caregiver/ui/screens/mytask_cg_screen.dart';
import 'package:ehtemam_final_project/features/payment_cg/ui/screens/cg_payment_screen.dart';
import 'package:ehtemam_final_project/features/rating_overview/ui/screens/provider_reviews_screen.dart';
import 'package:flutter/material.dart';

class MenuOptionsCard extends StatelessWidget {
  const MenuOptionsCard({super.key});

  List<_MenuOption> _buildOptions(BuildContext context) => [
  _MenuOption(
    icon: Icons.settings_outlined,
    label: "Account Settings",
    iconColor: AppColors.blue,
    bgColor: const Color.fromARGB(255, 240, 249, 255),
    onTap: () => Navigator.push(context, MaterialPageRoute(
      builder: (_) => const CareProviderAccountSettingsScreen(),
    )),
  ),
  _MenuOption(
    icon: Icons.attach_money,
    label: "Payments Received",
    iconColor: AppColors.blue,
    bgColor: const Color.fromARGB(255, 240, 249, 255),
    onTap: () => Navigator.push(context, MaterialPageRoute(
      builder: (_) => const CgPaymentScreen(),
    )),
  ),
  _MenuOption(
    icon: Icons.star_outline,
    label: "My Ratings",
    iconColor: AppColors.orange,
    bgColor: const Color.fromARGB(255, 255, 251, 235),
    onTap: () => Navigator.push(context, MaterialPageRoute(
      builder: (_) => const ProviderReviewsScreen(),
    )),
  ),
  _MenuOption(
    icon: Icons.check_box_outlined,
    label: "My Tasks",
    iconColor: AppColors.purple2,
    bgColor: const Color.fromARGB(255, 240, 249, 255),
    onTap: () => Navigator.push(context, MaterialPageRoute(
      builder: (_) => const MytaskCgScreen(),
    )),
  ),
];
  

  @override
Widget build(BuildContext context) {
  final options = _buildOptions(context);
  return Container(
    margin: const EdgeInsets.all(12),
    padding: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 241, 245, 249),
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4),
        BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6),
      ],
    ),
    child: Column(
      children: List.generate(options.length, (index) {
        return Column(
          children: [
            _MenuOptionTile(option: options[index]),
            if (index < options.length - 1)
              const Divider(
                height: 1,
                thickness: 0.5,
                indent: 16,
                endIndent: 16,
                color: Color(0xFFE5E7EB),
              ),
          ],
        );
      }),
    ),
  );
}
}

class _MenuOption {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback? onTap;

  const _MenuOption({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.bgColor,
    this.onTap,
  });
}


class _MenuOptionTile extends StatelessWidget {
  final _MenuOption option;

  const _MenuOptionTile({required this.option});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: option.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: option.bgColor,       // ✅ light color as background
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  option.icon,
                  size: 18,
                  color: option.iconColor,   // ✅ colored icon on light bg
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option.label,
                style: const TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}