import 'package:flutter/material.dart';

class PendingApprovalCard extends StatelessWidget {
  final Map<String, dynamic> provider;
  final VoidCallback onViewDocuments;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const PendingApprovalCard({
    super.key,
    required this.provider,
    required this.onViewDocuments,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final status = provider['status'];

    final isPending = status == 'Pending';
    final isRejected = status == 'Rejected';
    final isApproved = status == 'Approved';

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xff97CCFD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider['name'],
                      style: const TextStyle(
                        color: Color(0xff111827),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      provider['type'],
                      style: const TextStyle(
                        color: Color(0xff2F93E6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              _StatusTag(
                text: status,
                isPending: isPending,
                isRejected: isRejected,
                isApproved: isApproved,
              ),
            ],
          ),

          const SizedBox(height: 18),

          _InfoText(
            title: 'Email',
            value: provider['email'],
          ),

          const SizedBox(height: 12),

          _InfoText(
            title: 'Phone Number',
            value: provider['phone'],
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
                const Text(
                  'Documents Required',
                  style: TextStyle(
                    color: Color(0xff111827),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (provider['documents'] as List)
                      .map(
                        (doc) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffEEF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.image_outlined,
                            size: 13,
                            color: Color(0xff2F93E6),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            doc,
                            style: const TextStyle(
                              color: Color(0xff2F93E6),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff2F93E6),
                    Color(0xff74BDF8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton.icon(
                onPressed: onViewDocuments,
                icon: const Icon(
                  Icons.remove_red_eye_outlined,
                  size: 18,
                  color: Colors.white,
                ),
                label: const Text(
                  'View Documents',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          if (isPending) ...[
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: OutlinedButton.icon(
                onPressed: onApprove,
                icon: const Icon(Icons.check_circle_outline, size: 17),
                label: const Text('Approve'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xff059669),
                  side: const BorderSide(color: Color(0xff059669)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: TextButton.icon(
                onPressed: onReject,
                icon: const Icon(Icons.cancel_outlined, size: 17),
                label: const Text('Reject'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final String text;
  final bool isPending;
  final bool isRejected;
  final bool isApproved;

  const _StatusTag({
    required this.text,
    required this.isPending,
    required this.isRejected,
    required this.isApproved,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color color;

    if (isPending) {
      bg = const Color(0xffFEF3C7);
      color = const Color(0xffD97706);
    } else if (isRejected) {
      bg = const Color(0xffFEE2E2);
      color = Colors.red;
    } else {
      bg = const Color(0xffDCFCE7);
      color = const Color(0xff059669);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String title;
  final String value;

  const _InfoText({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff64748B),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xff111827),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}