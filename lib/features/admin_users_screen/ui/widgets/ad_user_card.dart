import 'package:flutter/material.dart';

import '../../model/AD_user_model.dart';
import 'ad_user_tags_widget.dart';
import 'block_user_dialog.dart';


class AdUserCard extends StatelessWidget {
  final AdUserModel user;

  const AdUserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                child: Text(
                  user.name.substring(0, 2).toUpperCase(),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.more_vert),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Text(
                '${user.bookings} bookings',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                'Joined ${user.joinedDate}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          AdUserTagsWidget(
            isActive: user.isActive,
            isPremium: user.isPremium,
          ),

          const SizedBox(height: 12),

          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => BlockUserDialog(
                  name: user.name,
                  email: user.email,
                  onBlock: () {
                    Navigator.pop(context);
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.block,
              color: Colors.red,
              size: 18,
            ),
            label: const Text(
              'Block User',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}