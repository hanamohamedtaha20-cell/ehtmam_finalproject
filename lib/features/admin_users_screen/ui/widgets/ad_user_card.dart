import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../manager/ad_user_cubit.dart';
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
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xff2F93E6),
                child: Text(
                  user.name.length >= 2
                      ? user.name.substring(0, 2).toUpperCase()
                      : user.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xff111827),
                      ),
                    ),

                    const SizedBox(height: 4),

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

              const Icon(
                Icons.more_vert,
                color: Color(0xff94A3B8),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Text(
                '${user.bookingsCount} bookings',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),

              const Spacer(),

              Text(
                'Joined ${user.createdAt.split("T").first}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const AdUserTagsWidget(
            isActive: true,
            isPremium: false,
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
                    context
                        .read<AdUserCubit>()
                        .blockUser(user.id);
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