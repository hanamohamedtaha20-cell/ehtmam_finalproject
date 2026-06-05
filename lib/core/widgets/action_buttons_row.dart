import 'package:flutter/material.dart';

class ActionButtonsRow extends StatelessWidget {
  final String firstText;
  final String secondText;

  final VoidCallback onFirstTap;
  final VoidCallback onSecondTap;

  const ActionButtonsRow({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.onFirstTap,
    required this.onSecondTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// LEFT BUTTON
        Expanded(
          child: SizedBox(
            height: 42,

            child: OutlinedButton(
              onPressed: onFirstTap,

              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,

                side: const BorderSide(
                  color: Color(0xFFD6E4FF),
                  width: 1.2,
                ),

                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),

                padding: EdgeInsets.zero,
              ),

              child: Text(
                firstText,

                style: const TextStyle(
                  color: Color(0xFF4A90E2),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        /// RIGHT BUTTON
        Expanded(
          child: SizedBox(
            height: 42,

            child: ElevatedButton(
              onPressed: onSecondTap,

              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF4A90E2),

                elevation: 4,

                shadowColor:
                const Color(0xFF4A90E2)
                    .withOpacity(0.35),

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),

                padding: EdgeInsets.zero,
              ),

              child: Text(
                secondText,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}