import 'package:flutter/material.dart';

class SpecialInstructionsCard extends StatelessWidget {
  final String instructions;

  const SpecialInstructionsCard({
    super.key,
    this.instructions = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
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
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffF4F0E2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              instructions.isNotEmpty
                  ? instructions
                  : 'No special instructions provided.',
              style: const TextStyle(
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
