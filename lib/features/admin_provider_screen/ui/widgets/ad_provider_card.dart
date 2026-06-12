import 'package:flutter/material.dart';

import '../../model/ad_provider_model.dart';
import 'block_provider_dialog.dart';

class AdProviderCard extends StatelessWidget {
  final AdProviderModel provider;
  final VoidCallback onBlockConfirmed;

  const AdProviderCard({
    super.key,
    required this.provider,
    required this.onBlockConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    final initials = provider.name.trim().isNotEmpty
        ? provider.name.trim().substring(0, 1).toUpperCase()
        : 'P';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xff2F93E6),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: const TextStyle(
                        color: Color(0xff111827),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      provider.service,
                      style: const TextStyle(
                        color: Color(0xff6B7280),
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xffF59E0B),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${provider.rating.toStringAsFixed(1)} (${provider.reviews} reviews)',
                          style: const TextStyle(
                            color: Color(0xff64748B),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Text(
                          '${provider.requests} requests',
                          style: const TextStyle(
                            color: Color(0xff64748B),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${provider.earned.toStringAsFixed(0)} earned',
                          style: const TextStyle(
                            color: Color(0xff16A34A),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    if (provider.isVerified)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffDCFCE7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Verified',
                          style: TextStyle(
                            color: Color(0xff16A34A),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const Icon(
                Icons.more_vert,
                color: Color(0xff94A3B8),
                size: 18,
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Divider(
            color: Color(0xffE5E7EB),
            height: 1,
          ),

          const SizedBox(height: 10),

          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.35),
                builder: (_) => BlockProviderDialog(
                  provider: provider,
                  onBlock: onBlockConfirmed,
                ),
              );
            },
            icon: const Icon(
              Icons.block,
              color: Colors.red,
              size: 16,
            ),
            label: const Text(
              'Block Provider',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}