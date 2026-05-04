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
          child: Row(
              children: [
                Icon(Icons.arrow_back_ios, size: 14, color: AppColors.textDark),
                
              ],
            ),
          ),
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