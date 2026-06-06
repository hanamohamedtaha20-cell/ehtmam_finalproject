import 'package:flutter/material.dart';

void showContactDialog(
  BuildContext context, {
  required String name,
  required String speciality,
  required String phoneNumber,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Contact Caregiver",
        style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFE3F2FD),
            child: Icon(Icons.person, color: Color(0xFF3A8BD7), size: 32),
          ),
          const SizedBox(height: 12),
          Text(name,
              style: const TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          Text(speciality,
              style: const TextStyle(
                  fontFamily: "Arimo", fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone, color: Color(0xFF3A8BD7), size: 18),
              const SizedBox(width: 8),
              Text(phoneNumber,
                  style: const TextStyle(
                      fontFamily: "Arimo",
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close",
              style: TextStyle(fontFamily: "Arimo", color: Colors.grey)),
        ),
      ],
    ),
  );
}