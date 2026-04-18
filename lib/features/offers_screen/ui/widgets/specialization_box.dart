import 'package:flutter/material.dart';

class SpecializationBox extends StatelessWidget {
  const SpecializationBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 Box
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Color(0xFFF1F3F8),
            borderRadius: BorderRadius.circular(14),
          ),

          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Specialization",
                style: TextStyle(
                  color: Color(0xFF432DD7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
              "Pet Grooming & Training",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 13,
              ),
            ),]
          ),
        ),
      ],
    );
  }
}
