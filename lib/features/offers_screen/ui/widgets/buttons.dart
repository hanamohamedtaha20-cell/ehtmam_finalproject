import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// 🔹 زرار View Details
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              print("View Details 🔍");
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF3A8BD7)),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  "ViewDetails",
                  style: TextStyle(
                    color: Color(0xFF3A8BD7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 10),

        /// 🔹 زرار Process Payment
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              print("Process Payment 💸");
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3A8BD7),
                    Color(0xFFD8E3E9),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF432DD7).withOpacity(0.3),
                    offset: Offset(0, 6),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Process Payment",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
