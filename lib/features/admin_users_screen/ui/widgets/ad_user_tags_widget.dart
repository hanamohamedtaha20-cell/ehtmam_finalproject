import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdUserTagsWidget extends StatelessWidget {
  final bool isActive;
  final bool isPremium;
  final bool isBlocked;

  const AdUserTagsWidget({
    super.key,
    required this.isActive,
    required this.isPremium,
    this.isBlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isBlocked)
          _buildChip(
            text: 'Blocked',
            textColor: Colors.red,
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            icon: Icons.block,
          )
        else
          _buildChip(
            text: isActive ? 'Active' : 'Inactive',
            textColor: isActive ? Colors.green : Colors.grey,
            backgroundColor: isActive
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            icon: isActive ? Icons.check_circle : Icons.remove_circle,
          ),

        SizedBox(width: 8.w),

        _buildChip(
          text: isPremium ? 'Premium User' : 'User',
          textColor: isPremium ? Colors.purple : Colors.black54,
          backgroundColor: isPremium
              ? Colors.purple.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.1),
          icon: isPremium ? Icons.workspace_premium : Icons.person_outline,
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.r, color: textColor),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
