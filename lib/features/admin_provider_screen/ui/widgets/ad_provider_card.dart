import 'package:flutter/material.dart';
import '../../model/ad_provider_model.dart';
import 'block_provider_dialog.dart';


class AdProviderCard extends StatelessWidget {
  final AdProviderModel provider;

  const AdProviderCard({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                child: Text(
                  provider.name.substring(0, 2).toUpperCase(),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      provider.service,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 8),

                  ],
                ),
              ),

              const Icon(
                Icons.more_vert,
                color: Colors.grey,
                size: 18,
              ),
            ],
          ),

          const SizedBox(height: 10),

          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => BlockProviderDialog(
                  provider: provider,
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}