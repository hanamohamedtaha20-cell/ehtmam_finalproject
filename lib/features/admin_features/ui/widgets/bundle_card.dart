import 'package:flutter/material.dart';

import '../../data/bundle_model.dart';

class BundleCard extends StatelessWidget {
  final BundleModel bundle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BundleCard({
    super.key,
    required this.bundle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  bundle.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1E293B),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${bundle.price}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff1E293B),
                    ),
                  ),
                  const Text(
                    '0 sold',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xff94A3B8),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _Info(
                value: '${bundle.sessions}',
                title: 'sessions',
              ),

              const SizedBox(width: 24),

              _Info(
                value: bundle.validity,
                title: 'days',
              ),

              const SizedBox(width: 24),

              _Info(
                value: '${bundle.discount}%',
                title: 'off',
                green: true,
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                  ),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xff2F93E6),
                    side: const BorderSide(
                      color: Color(0xffB8D8F7),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 16,
                  ),
                  label: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String value;
  final String title;
  final bool green;

  const _Info({
    required this.value,
    required this.title,
    this.green = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: green
                ? const Color(0xff16A34A)
                : const Color(0xff334155),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xff64748B),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}