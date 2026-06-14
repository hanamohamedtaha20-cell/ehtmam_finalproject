import 'package:flutter/material.dart';

import '../../data/complaint_model.dart';


class ComplaintDetailsDialog extends StatelessWidget {
  final ComplaintModel complaint;

  const ComplaintDetailsDialog({
    super.key,
    required this.complaint,
  });

  @override
  Widget build(BuildContext context) {
    final isResolved = complaint.status.toLowerCase() == 'resolved';

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xff2F93E6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Complaint Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
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

                  const SizedBox(height: 12),

                  Text(
                    complaint.title,
                    style: const TextStyle(
                      color: Color(0xff1E293B),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Category: ${complaint.category}',
                    style: const TextStyle(
                      color: Color(0xff64748B),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xffF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _detailsText(
                          title: 'Complainant',
                          value:
                          '${complaint.fromName} (${complaint.fromRole})',
                        ),
                        const SizedBox(height: 10),
                        _detailsText(
                          title: 'Against',
                          value:
                          '${complaint.againstName} (${complaint.againstRole})',
                        ),
                        const SizedBox(height: 10),
                        _detailsText(
                          title: 'Date Submitted',
                          value: complaint.date,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Description',
                    style: TextStyle(
                      color: Color(0xff334155),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFBEA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xffFACC15),
                      ),
                    ),
                    child: Text(
                      complaint.description,
                      style: const TextStyle(
                        color: Color(0xff334155),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailsText({
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xff64748B),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xff1E293B),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}