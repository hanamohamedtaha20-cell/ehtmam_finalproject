import 'package:flutter/material.dart';
import 'contact_dialog.dart';

class ContactButton extends StatelessWidget {
  final String name;
  final String speciality;
  final String phoneNumber;

  const ContactButton({
    super.key,
    required this.name,
    required this.speciality,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () => showContactDialog(
          context,
          name: name,
          speciality: speciality,
          phoneNumber: phoneNumber,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF3A8BD7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.contact_phone, color: Colors.white, size: 18),
              SizedBox(width: 6),
              Text(
                "Contact",
                style: TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}