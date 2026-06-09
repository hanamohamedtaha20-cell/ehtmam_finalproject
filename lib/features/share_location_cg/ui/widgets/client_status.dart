import 'package:flutter/material.dart';

class ClientStatus extends StatelessWidget {
  final String status;
  final String statusSubtitle;

  const ClientStatus({
    super.key,
    required this.status,
    required this.statusSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.circle, color: Colors.orange, size: 15),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(status, style: const TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
                Text(statusSubtitle, style: const TextStyle(fontFamily: "Arimo", fontSize: 12, color: Colors.black45)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.access_time, color: Colors.blue, size: 15),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Arriving Soon", style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
                const Text("Expected in 15 min.", style: TextStyle(fontFamily: "Arimo", fontSize: 12, color: Colors.black45)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}