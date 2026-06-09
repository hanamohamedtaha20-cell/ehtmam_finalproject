import 'package:flutter/material.dart';

class SpecialInstructionsCard extends StatelessWidget {
  const SpecialInstructionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 20,
      ),

      decoration: BoxDecoration(
        color: Color(0xffF8F8F8),

        borderRadius: BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// HEADER
          Row(
            children:  [

              Icon(
                Icons.description_outlined,
                color: Color(0xff4B5A75),
                size: 18,
              ),

              SizedBox(width: 8),

              Text(
                "SPECIAL INSTRUCTIONS",

                style: TextStyle(
                  color: Color(0xff4B5A75),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

           SizedBox(height: 14),

          /// NOTE BOX
          Container(
            width: double.infinity,

            padding:  EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

            decoration: BoxDecoration(
              color:  Color(0xffF4F0E2),

              borderRadius: BorderRadius.circular(20),
            ),

            child:  Text(
              "Max loves to play fetch and needs his medication at 12 PM. Please make sure he has fresh water at all times.",

              style: TextStyle(
                color: Color(0xff31456A),
                fontSize: 13,
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