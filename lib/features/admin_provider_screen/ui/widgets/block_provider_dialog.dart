import 'package:flutter/material.dart';

import '../../model/ad_provider_model.dart';

class BlockProviderDialog extends StatelessWidget {
  final AdProviderModel provider;
  final VoidCallback onBlock;

  const BlockProviderDialog({
    super.key,
    required this.provider,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    final reasonController = TextEditingController();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Block Provider',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              'Provider:',
              style: TextStyle(
                color: Color(0xff64748B),
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              provider.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xff111827),
              ),
            ),

            Text(
              provider.service,
              style: const TextStyle(
                color: Color(0xff64748B),
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Reason for Blocking *',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xff111827),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Explain why you are blocking this provider...',
                hintStyle: const TextStyle(
                  color: Color(0xff94A3B8),
                  fontSize: 13,
                ),
                filled: true,
                fillColor: const Color(0xffF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xffE2E8F0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xffE2E8F0),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'This reason will be stored for record keeping and may be shared with the provider.',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xff64748B),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF1F5F9),
                        foregroundColor: const Color(0xff334155),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        onBlock();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: const Text('Block'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}