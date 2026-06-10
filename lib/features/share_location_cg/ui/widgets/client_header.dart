import 'package:flutter/material.dart';

class ClientHeader extends StatelessWidget {
  final String name;
  final String serviceType;

  const ClientHeader({
    super.key,
    required this.name,
    required this.serviceType,
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
              Text(name, style: const TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
              Text(serviceType, style: const TextStyle(fontFamily: "Arimo", fontSize: 14, color: Colors.black87)),
              Text('Waiting for your arrival', style: const TextStyle(fontFamily: "Arimo", fontSize: 12, color: Colors.black87)),

            ],
          ),
        ),
      ],
    );
  }
}