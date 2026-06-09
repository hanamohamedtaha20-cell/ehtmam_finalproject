import 'package:flutter/material.dart';

class HcHeaderSection extends StatelessWidget {
  const HcHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 32,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFC9E0EF),
            Color(0xFFEAF5FF),
            Color(0xFFC9D7F4),
          ],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome back,',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Color(0xff7C8DA0),
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Sarah's Care Services",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xff1F2937),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Sunday, March 8, 2026',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}