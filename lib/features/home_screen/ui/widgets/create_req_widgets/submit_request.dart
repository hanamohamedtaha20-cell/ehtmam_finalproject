import 'package:flutter/material.dart';

class SubmitRequest extends StatelessWidget {
  final VoidCallback onSubmit;

  const SubmitRequest({
    super.key,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,

      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18
          ),

          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF8EC5FC),
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 6),
            ),
          ],
        ),

        child: ElevatedButton.icon(
          onPressed: onSubmit,

          icon: const Icon(
            Icons.send_outlined,
            color: Colors.white,
            size: 18,
          ),

          label: const Text(
            "Submit Request",

            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19),
            ),
          ),
        ),
      ),
    );
  }
}