import 'package:flutter/material.dart';

class LocationStatusBanner extends StatelessWidget {
  final String eta;
  final String distance;
  final bool isSharing;

  const LocationStatusBanner({
    super.key,
    required this.eta,
    required this.distance,
    this.isSharing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3A8BD7), Color(0xFF97CCFD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.circle, color: isSharing ? Colors.greenAccent : Colors.white54, size: 10),
              const SizedBox(width: 3),
              Text(
                isSharing ? "Location Sharing Active" : "Location Sharing Inactive",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Start sharing your location to let the client track your arrival"
              ,style: const TextStyle(color: Colors.white70, fontSize: 14),

          )
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String label;
  final String value;
  const _Item({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontFamily: "Arimo", fontSize: 11, color: Colors.white70)),
        Text(value, style: const TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
      ],
    );
  }
}