import 'package:flutter/material.dart';

class HcAvailabilityCard extends StatelessWidget {
  final bool isAvailable;
  final ValueChanged<bool> onChanged;

  const HcAvailabilityCard({
    super.key,
    required this.isAvailable,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final s = (width / 390).clamp(0.85, 1.15);

    return Padding(
      padding: EdgeInsets.fromLTRB(16 * s, 16 * s, 16 * s, 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 14 * s),
        decoration: BoxDecoration(
          color: const Color(0xFFE8FBF3),
          borderRadius: BorderRadius.circular(16 * s),
          border: Border.all(color: const Color(0xFFD1F2E3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Availability Status',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15 * s,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0B2B5A),
                    ),
                  ),
                  SizedBox(height: 2 * s),
                  Text(
                    isAvailable
                        ? 'You are currently accepting requests'
                        : 'You are currently unavailable',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12 * s,
                      color: const Color(0xFF667085),
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: isAvailable,
              activeTrackColor: const Color(0xFF3A8BD7),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
