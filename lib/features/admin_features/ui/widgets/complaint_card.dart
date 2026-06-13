import 'package:flutter/material.dart';

import '../../data/complaint_model.dart';


class ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;
  final VoidCallback onViewDetails;

  const ComplaintCard({
    super.key,
    required this.complaint,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isResolved = complaint.status.toLowerCase() == 'resolved';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: isResolved
                  ? const Color(0xffDCFCE7)
                  : const Color(0xffFEF3C7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              complaint.status,
              style: TextStyle(
                color: isResolved
                    ? const Color(0xff16A34A)
                    : const Color(0xffF59E0B),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            complaint.title,
            style: const TextStyle(
              color: Color(0xff1E293B),
              fontSize: 15,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Category: ${complaint.category}',
            style: const TextStyle(
              color: Color(0xff64748B),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          _infoRow(
            icon: Icons.person_outline,
            iconColor: Color(0xff2F93E6),
            text:
            'From: ${complaint.fromName} (${complaint.fromRole})',
          ),
          const SizedBox(height: 5),
          _infoRow(
            icon: Icons.error_outline,
            iconColor: Colors.red,
            text:
            'Against: ${complaint.againstName} (${complaint.againstRole})',
          ),
          const SizedBox(height: 5),
          _infoRow(
            icon: Icons.access_time,
            iconColor: Color(0xff64748B),
            text: complaint.date,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton.icon(
              onPressed: onViewDetails,
              icon: const Icon(Icons.remove_red_eye_outlined, size: 14),
              label: const Text('View Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffEEF4FF),
                foregroundColor: const Color(0xff2F93E6),
                elevation: 0,
                textStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xff334155),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}