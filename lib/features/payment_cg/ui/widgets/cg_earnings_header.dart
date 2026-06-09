import 'package:flutter/material.dart';

class CgEarningsHeader extends StatelessWidget {
  final double totalEarned;
  final double pending;

  const CgEarningsHeader({
    super.key,
    required this.totalEarned,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          icon: Icons.attach_money,
          label: 'Total Earned',
          value: '${totalEarned.toStringAsFixed(2)}',
          color: const Color(0xFF3A8BD7),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.access_time,
          label: 'Pending',
          value: '${pending.toStringAsFixed(2)}',
          color: const Color(0xFF97CCFD),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 3),
                 Text(label, style: const TextStyle(fontFamily: "Arimo", fontSize: 12, color: Colors.white70)),
             ],
            ),
            const SizedBox(height: 8,),
            Text(value, style: const TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}