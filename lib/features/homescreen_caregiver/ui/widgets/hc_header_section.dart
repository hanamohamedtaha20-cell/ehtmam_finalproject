import 'package:ehtemam_final_project/features/home_screen/ui/widgets/language_switcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HcHeaderSection extends StatelessWidget {
  final String businessTitle;

  const HcHeaderSection({
    super.key,
    required this.businessTitle,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final s = (width / 390).clamp(0.85, 1.15);
    final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16 * s, 8 * s, 16 * s, 20 * s),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFDCEEFF),
            Color(0xFFF5F7FB),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF3A8BD7),
                  ),
                ),
                SizedBox(height: 4 * s),
                Text(
                  businessTitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24 * s,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0B2B5A),
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 6 * s),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13 * s,
                    color: const Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
          const LanguageSwitcher(),
        ],
      ),
    );
  }
}
