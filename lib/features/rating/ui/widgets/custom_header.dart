import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:ehtemam_final_project/features/home_screen/ui/widgets/language_switcher.dart';
import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 2),
                    blurRadius: 4),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.arrow_back_ios, size: 14, color: AppColors.textDark),
                SizedBox(width: 4),
                Text("Back",
                    style: TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20,),
        const Spacer(),
        
        const Spacer(),
        const LanguageSwitcher(),
      ],
    );
  }
}