import 'package:flutter/material.dart';

class LocationDetails extends StatelessWidget {
  final String userLocation;
  final String caregiverLocation;
  final String distance;
  final String eta;

  const LocationDetails({
    super.key,
    required this.userLocation,
    required this.caregiverLocation,
    required this.distance,
    required this.eta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
       padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(55, 0, 0, 0),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
        child: Column(
          children: [
            _LocationRow(
              icon: Icons.location_on,
              iconColor: const Color(0xFF3A8BD7),
              title: "Your Location",
              subtitle: userLocation,
            ),
            const SizedBox(height: 12),
            _LocationRow(
              icon: Icons.person_pin_circle,
              iconColor: Colors.green,
              title: "Caregiver's Current Location",
              distance: "$distance • $eta",
            ),
          ],
        ),
      );
  }
}

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final String? distance;

  const _LocationRow({
    required this.icon,
    required this.iconColor,
    required this.title,
     this.subtitle,
     this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: "Arimo",
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
              if (subtitle != null)
              Text(
                subtitle!,
                style: const TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
               if (distance != null)
              Text(
                distance!,
                style: const TextStyle(
                  fontFamily: "Arimo",
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}