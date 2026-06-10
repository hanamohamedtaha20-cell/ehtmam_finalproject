import 'package:flutter/material.dart';

class AdUserTagsWidget extends StatelessWidget {
  final bool isActive;
  final bool isPremium;

  const AdUserTagsWidget({
    super.key,
    required this.isActive,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildChip(
          text: isActive ? 'Active' : 'Inactive',
          textColor: isActive ? Colors.green : Colors.grey,
          backgroundColor: isActive
              ? Colors.green.withOpacity(.1)
              : Colors.grey.withOpacity(.1),
          icon: isActive
              ? Icons.check_circle
              : Icons.remove_circle,
        ),

        const SizedBox(width: 8),

        _buildChip(
          text: isPremium ? 'Premium User' : 'User',
          textColor: isPremium ? Colors.purple : Colors.black54,
          backgroundColor: isPremium
              ? Colors.purple.withOpacity(.1)
              : Colors.grey.withOpacity(.1),
          icon: isPremium
              ? Icons.workspace_premium
              : Icons.person_outline,
        ),
      ],
    );
  }

  Widget _buildChip({
    required String text,
    required Color textColor,
    required Color backgroundColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}