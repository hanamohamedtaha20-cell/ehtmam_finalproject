import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final Widget child;
  const SectionCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        // boxShadow: const [
        //   BoxShadow(
        //       color: Color(0x1A000000),
        //       offset: Offset(0, 2),
        //       blurRadius: 4,
        //       spreadRadius: 0),
        //   BoxShadow(
        //       color: Color(0x1A000000),
        //       offset: Offset(0, 4),
        //       blurRadius: 6,
        //       spreadRadius: 0),
        // ],
      ),
      child: child,
    );
  }
}