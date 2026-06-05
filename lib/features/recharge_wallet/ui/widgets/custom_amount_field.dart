import 'package:flutter/material.dart';

class CustomAmountField extends StatelessWidget {
  final TextEditingController controller;

  const CustomAmountField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(fontFamily: "Arimo", fontSize: 14),
      ),
    );
  }
}