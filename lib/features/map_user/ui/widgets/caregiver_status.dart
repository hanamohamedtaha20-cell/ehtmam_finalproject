import 'package:flutter/material.dart';

class CaregiverStatus extends StatelessWidget {
  final String status;
  final String statusSubtitle;

  const CaregiverStatus({
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
            const Icon(Icons.circle, color: Colors.green, size: 15),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(status,
                    style: const TextStyle(
                        fontFamily: "Arimo",
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black)),
                Text(statusSubtitle,
                    style: const TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 12,
                        color: Colors.black45)),
              ],
            ),
          ],
        ),
         SizedBox(height: 4,),

        Row(
          children: [
            const Icon(Icons.access_time, color: Colors.blue, size: 15),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Arriving Soon",
                    style: const TextStyle(
                        fontFamily: "Arimo",
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black)),
                Text("Expected in 14 min.",
                    style: const TextStyle(
                        fontFamily: "Arimo",
                        fontSize: 12,
                        color: Colors.black45)),
              ],
            ),
          ],
        ),
        
       
      ],
    );
  }
}