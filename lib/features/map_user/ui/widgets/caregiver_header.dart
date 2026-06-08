import 'package:flutter/material.dart';

class CaregiverHeader extends StatelessWidget {
  final String name;
  final String speciality;
  final String rating;
  final String reviewCount;

  const CaregiverHeader({
    super.key,
    required this.name,
    required this.speciality,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 28,
          backgroundColor: Color(0xFFE3F2FD),
          child: Icon(Icons.person, color: Color(0xFF3A8BD7), size: 30),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontFamily: "Arimo",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black)),
              Text(speciality,
                  style: const TextStyle(
                      fontFamily: "Arimo",
                      fontSize: 12,
                      color: Colors.black45)),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "$rating ($reviewCount reviews)",
                    style: const TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 12,
                        color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}