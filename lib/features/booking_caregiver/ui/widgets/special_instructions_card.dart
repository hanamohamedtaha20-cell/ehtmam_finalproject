import 'package:flutter/material.dart';

class SpecialInstructionsCard extends StatelessWidget {
  const SpecialInstructionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 22,
      ),

      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),

        borderRadius: BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// HEADER
          Row(
            children: const [

              Icon(
                Icons.description_outlined,
                color: Color(0xff4B5A75),
                size: 20,
              ),

              SizedBox(width: 8),

              Text(
                "SPECIAL INSTRUCTIONS",

                style: TextStyle(
                  color: Color(0xff4B5A75),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// NOTE BOX
          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),

            decoration: BoxDecoration(
              color: const Color(0xffF4F0E2),

              borderRadius: BorderRadius.circular(20),
            ),

            child: const Text(
              "Max loves to play fetch and needs his medication at 12 PM. Please make sure he has fresh water at all times.",

              style: TextStyle(
                color: Color(0xff31456A),
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}