import 'package:flutter/material.dart';

class StartSharingButton extends StatelessWidget {
  final bool isSharing;
  final VoidCallback onTap;

  const StartSharingButton({
    super.key,
    required this.isSharing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(left: 8, right: 8),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSharing ? Colors.red : const Color(0xFF1F9E0E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isSharing ? Icons.stop : Icons.share, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                isSharing ? "Stop Sharing Location" : "Start Sharing Location",
                style: const TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}