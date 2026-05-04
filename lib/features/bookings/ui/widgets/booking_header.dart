import 'package:ehtemam_final_project/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class BookingHeader extends StatelessWidget {
  const BookingHeader({super.key});

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
                        color: AppColors.textDark)),
              ],
            ),
          ),
        ),
        const Spacer(),
        const Text(
          "myBookings",
          style: TextStyle(
              fontFamily: "Arimo",
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textDark),
        ),
        const Spacer(),
        //Localization
      ],
    );
  }
}