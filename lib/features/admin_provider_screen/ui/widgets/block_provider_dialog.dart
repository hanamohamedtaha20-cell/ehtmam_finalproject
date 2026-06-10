import 'package:ehtemam_final_project/core/widgets/action_buttons_row.dart';
import 'package:ehtemam_final_project/features/admin_provider_screen/model/ad_provider_model.dart';
import 'package:flutter/material.dart';

class BlockProviderDialog extends StatelessWidget {
  const BlockProviderDialog({super.key, required AdProviderModel provider});

  @override
  Widget build(BuildContext context) {
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
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              'Provider:',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Sarah Johnson',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const Text(
              'sarah.j@email.com',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Reason for Blocking *',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                'Explain why you are blocking this user...',
                filled: true,
                fillColor: const Color(0xffE5E7EB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'This reason will be stored for record keeping and may be shared with the user.',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            ActionButtonsRow(firstText: "Cancel", secondText: "Block Provider",
              onFirstTap: () {
                Navigator.pop(context);
              },
              onSecondTap: () {
                // block provider
              },
            )
          ],
        ),
      ),
    );
  }
}